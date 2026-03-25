import { expect, test } from '@playwright/test';

test.describe('Core.Control Showcase - /families/scheduling - MxScheduler runtime', () => {
  test('valida navegación mensual, selección, loading, empty, theming y ausencia de errores runtime', async ({ page }) => {
    const runtimeErrors: string[] = [];

    page.on('pageerror', (error) => {
      runtimeErrors.push(`pageerror:${error.message}`);
    });

    page.on('console', (message) => {
      if (message.type() === 'error') {
        runtimeErrors.push(`console:${message.text()}`);
      }
    });

    const websocketPromise = page.waitForEvent(
      'websocket',
      (websocket) => websocket.url().includes('/_blazor?id='),
      { timeout: 45_000 }
    );

    await page.goto('/families/scheduling', { waitUntil: 'domcontentloaded' });
    await page.waitForResponse(
      (response) => response.url().includes('/_blazor/negotiate') && response.status() === 200,
      { timeout: 30_000 }
    );
    const websocket = await websocketPromise;
    await websocket.waitForEvent('framereceived', { timeout: 45_000 });
    await page.waitForTimeout(1500);

    await expect(page.getByRole('heading', { name: 'MxScheduler' })).toBeVisible();

    const scheduler = page.locator('[data-testid="scheduler-base"]').first();
    await expect(scheduler).toBeVisible();
    const monthTitle = scheduler.locator('.mx-scheduler__title');
    await expect(monthTitle).toContainText('2026');
    const initialMonth = (await monthTitle.textContent())?.trim();

    await scheduler.getByRole('button', { name: 'Periodo anterior' }).evaluate((element) => {
      (element as HTMLButtonElement).click();
    });
    await expect
      .poll(async () => (await monthTitle.textContent())?.trim(), { timeout: 10_000 })
      .not.toBe(initialMonth);
    const previousMonth = (await monthTitle.textContent())?.trim();
    expect(previousMonth).not.toBe(initialMonth);
    await expect(page.getByText(new RegExp(`Mes visible: ${previousMonth}`))).toBeVisible();

    await scheduler.getByRole('button', { name: 'Periodo siguiente' }).evaluate((element) => {
      (element as HTMLButtonElement).click();
    });
    await expect(monthTitle).toHaveText(initialMonth ?? '', { timeout: 10_000 });

    await scheduler.getByRole('button', { name: 'Periodo anterior' }).evaluate((element) => {
      (element as HTMLButtonElement).click();
    });
    await expect(monthTitle).toHaveText(previousMonth ?? '', { timeout: 10_000 });

    await scheduler.getByRole('button', { name: 'Hoy' }).evaluate((element) => {
      (element as HTMLButtonElement).click();
    });
    await expect(monthTitle).toHaveText(initialMonth ?? '', { timeout: 10_000 });

    const standupEvent = scheduler.getByRole('button', { name: /09:00 · Standup de operaciones/ }).first();
    await standupEvent.click();
    await expect(standupEvent).toHaveClass(/mx-scheduler__event--selected/);
    await expect(page.getByText(/Selección actual: Standup de operaciones/)).toBeVisible();

    const loadingScheduler = page.locator('[data-testid="scheduler-loading"]').first();
    await expect(loadingScheduler).toBeVisible();
    await page.getByRole('button', { name: 'Activar loading' }).click();
    await expect(loadingScheduler.getByText('Cargando agenda del equipo...')).toBeVisible();
    await page.getByRole('button', { name: 'Detener loading' }).click();
    await expect(loadingScheduler.getByText('Cargando agenda del equipo...')).not.toBeVisible();

    const emptyScheduler = page.locator('[data-testid="scheduler-empty"]').first();
    await expect(emptyScheduler.getByText('No hay eventos programados para este mes operativo.')).toBeVisible();

    const themeSwitch = page.locator('#mx-showcase-theme-switch');
    await themeSwitch.scrollIntoViewIfNeeded();
    await themeSwitch.setChecked(true, { force: true });
    await expect(page.locator('.ms-control-shell')).toHaveAttribute('data-mx-theme', 'dark');
    await expect(scheduler).toBeVisible();

    await themeSwitch.setChecked(false, { force: true });
    await expect(page.locator('.ms-control-shell')).toHaveAttribute('data-mx-theme', 'light');

    expect(runtimeErrors, `Errores runtime detectados: ${runtimeErrors.join(' | ')}`).toEqual([]);
  });
});
