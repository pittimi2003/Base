import { expect, test } from '@playwright/test';

test.describe('Core.Control Showcase - jerarquía visual de Families', () => {
  test('renderiza Families en panel nivel 1 y Family - ... en panel nivel 2 como columnas hermanas', async ({
    page
  }) => {
    await page.goto('/', { waitUntil: 'domcontentloaded' });
    await page.waitForResponse(
      (response) => response.url().includes('/_blazor/negotiate') && response.status() === 200,
      { timeout: 30_000 }
    );
    await page.waitForSelector('[data-ms-shell-interactive="true"]', { timeout: 30_000 });

    const toggleMenuButton = page.getByRole('button', { name: 'Abrir o cerrar navegación' });
    if (await toggleMenuButton.isVisible()) {
      await toggleMenuButton.click();
    }

    await page.getByRole('button', { name: 'Families' }).click();

    const levelOneColumn = page.locator('.ms-nav__panel-column[data-ms-nav-depth="0"]');
    const levelTwoColumn = page.locator('.ms-nav__panel-column[data-ms-nav-depth="1"]');
    const levelOnePanel = levelOneColumn.locator('.ms-nav__panel');
    const levelTwoPanel = levelTwoColumn.locator('.ms-nav__panel');

    await expect(levelOnePanel).toBeVisible();
    await expect(levelTwoPanel).toBeVisible();
    await expect(levelOnePanel).toContainText('Families');
    await expect(levelTwoPanel).toContainText('Family - Data');
    await expect(levelOnePanel).not.toContainText('Family - Data');

    const levelOneBox = await levelOneColumn.boundingBox();
    const levelTwoBox = await levelTwoColumn.boundingBox();

    expect(levelOneBox).not.toBeNull();
    expect(levelTwoBox).not.toBeNull();
    expect(levelTwoBox!.width).toBeGreaterThanOrEqual(230);
    expect(levelTwoBox!.x - (levelOneBox!.x + levelOneBox!.width)).toBeGreaterThanOrEqual(10);

    const levelOneStyle = await levelOnePanel.evaluate((element) => {
      const style = window.getComputedStyle(element);
      return {
        borderRadius: style.borderRadius,
        borderColor: style.borderColor,
        backgroundColor: style.backgroundColor
      };
    });

    const levelTwoStyle = await levelTwoPanel.evaluate((element) => {
      const style = window.getComputedStyle(element);
      return {
        borderRadius: style.borderRadius,
        borderColor: style.borderColor,
        backgroundColor: style.backgroundColor
      };
    });

    expect(levelTwoStyle).toEqual(levelOneStyle);
  });
});
