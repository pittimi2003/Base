import { expect, test } from '@playwright/test';

test.describe('Core.Control Showcase - /families/data - MxDataGrid enterprise', () => {
  test('valida sorting, selección, toolbar, row actions, summary y light/dark sin errores runtime', async ({ page }) => {
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

    await page.goto('/families/data', { waitUntil: 'domcontentloaded' });
    await page.waitForResponse(
      (response) => response.url().includes('/_blazor/negotiate') && response.status() === 200,
      { timeout: 30_000 }
    );
    const websocket = await websocketPromise;
    await websocket.waitForEvent('framereceived', { timeout: 45_000 });

    await expect(page.getByRole('heading', { name: 'MxDataGrid' })).toBeVisible();

    const enterpriseGrid = page.locator('.mx-data-grid-scroll[aria-label="Órdenes operativas del turno"]').first();
    await expect(enterpriseGrid).toBeVisible();

    const enterpriseBodyRows = enterpriseGrid.locator('tbody tr');
    await expect(enterpriseBodyRows).toHaveCount(4);
    await expect(enterpriseBodyRows.nth(0).locator('td').nth(0)).toContainText('ORD-1045');

    const orderSortButton = enterpriseGrid.getByRole('button', { name: /Ordenar por Orden/i });
    const orderHeader = enterpriseGrid.locator('th', { has: orderSortButton }).first();

    await orderSortButton.click({ force: true });
    await expect(orderHeader).toHaveAttribute('aria-sort', 'ascending');
    await expect(orderSortButton).toHaveAttribute('aria-label', 'Ordenar por Orden descendente');
    await expect(enterpriseBodyRows.nth(0).locator('td').nth(0)).toContainText('ORD-1042');

    await orderSortButton.click({ force: true });
    await expect(orderHeader).toHaveAttribute('aria-sort', 'descending');
    await expect(enterpriseBodyRows.nth(0).locator('td').nth(0)).toContainText('ORD-1045');

    await enterpriseGrid.getByRole('button', { name: 'Ver detalle' }).first().click();
    await expect(page.getByText('Última acción de fila: Vista previa de ORD-1045')).toBeVisible();
    await enterpriseGrid.getByRole('button', { name: 'Marcar como completada' }).first().click();
    await expect(page.getByText('Última acción de fila: Orden ORD-1045 marcada para cierre operativo.')).toBeVisible();
    await expect(enterpriseGrid.locator('tfoot .mx-data-grid__summary')).toContainText('Total visible: 4 filas');

    const multiGrid = page.locator('.mx-data-grid-scroll[aria-label="Grid con selección de órdenes"]').first();
    const multiGridRoot = multiGrid.locator('xpath=ancestor::div[contains(@class,"mx-data-grid-root")][1]');
    await expect(multiGrid).toBeVisible();
    await multiGrid.locator('tbody tr').nth(0).locator('.mx-data-grid__select-input').check();
    await multiGrid.locator('tbody tr').nth(1).locator('.mx-data-grid__select-input').check();
    await expect(page.getByText('IDs seleccionados: ORD-1042, ORD-1043')).toBeVisible();
    await expect(multiGridRoot.locator('.mx-data-grid__selection-summary')).toContainText('2 seleccionada(s)');

    await multiGrid.getByRole('button', { name: 'Ordenar por Estado ascendente' }).click();
    await expect(page.getByText('IDs seleccionados: ORD-1042, ORD-1043')).toBeVisible();

    const singleGrid = page.locator('.mx-data-grid-scroll[aria-label="Grid con selección simple de órdenes"]').first();
    await expect(singleGrid).toBeVisible();
    await singleGrid.locator('tbody tr').nth(2).locator('.mx-data-grid__select-input').check();
    await expect(page.getByText('ID seleccionado: ORD-1044')).toBeVisible();
    await singleGrid.locator('tbody tr').nth(1).locator('.mx-data-grid__select-input').check();
    await expect(page.getByText('ID seleccionado: ORD-1043')).toBeVisible();

    const loadingToggle = page.getByRole('button', { name: 'Activar loading' });
    await loadingToggle.click();
    await expect(page.getByText('Consultando órdenes del turno...')).toBeVisible();
    await page.getByRole('button', { name: 'Detener loading' }).click();
    await expect(page.getByText('Consultando órdenes del turno...')).not.toBeVisible();

    const themeSwitch = page.locator('#mx-showcase-theme-switch');
    await themeSwitch.scrollIntoViewIfNeeded();
    await themeSwitch.setChecked(true, { force: true });
    await expect(page.locator('.ms-control-shell')).toHaveAttribute('data-mx-theme', 'dark');
    await expect(enterpriseGrid).toBeVisible();
    await themeSwitch.setChecked(false, { force: true });
    await expect(page.locator('.ms-control-shell')).toHaveAttribute('data-mx-theme', 'light');

    expect(runtimeErrors, `Errores runtime detectados: ${runtimeErrors.join(' | ')}`).toEqual([]);
  });
});
