import { expect, test } from '@playwright/test';
import { shellSelectors } from './support/shell-selectors';
import { waitForBlazorServerReady } from './support/blazor-ready';

test.describe('AppShell desktop behavior', () => {
  test.beforeEach(async ({ page }, testInfo) => {
    test.skip(testInfo.project.name !== 'desktop', 'Desktop-only assertions.');
    await waitForBlazorServerReady(page, { requireMenuVisible: false });
  });

  test('shows fixed sidebar by default and hides mobile controls', async ({ page }) => {
    await expect(page.locator(shellSelectors.nav)).toBeVisible();
    await expect(page.locator(shellSelectors.menuButton)).toBeHidden();
    await expect(page.locator(shellSelectors.overlay)).toBeHidden();
  });

  test('navigates between core routes from sidebar', async ({ page }) => {
    await page.locator(shellSelectors.showcaseLink).click();
    await expect(page).toHaveURL(/\/showcase$/);

    await page.locator(shellSelectors.demoLink).click();
    await expect(page).toHaveURL(/\/demo$/);

    await page.locator(shellSelectors.homeLink).click();
    await expect(page).toHaveURL(/\/$/);
  });
});
