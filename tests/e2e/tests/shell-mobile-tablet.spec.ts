import { expect, test } from '@playwright/test';
import { shellSelectors } from './support/shell-selectors';

test.describe('AppShell mobile/tablet behavior', () => {
  test.beforeEach(async ({ page }, testInfo) => {
    test.skip(testInfo.project.name === 'desktop', 'Mobile/Tablet-only assertions.');
    await page.goto('/');
  });

  test('opens menu with hamburger and shows overlay', async ({ page }) => {
    const menuButton = page.locator(shellSelectors.menuButton);
    const nav = page.locator(shellSelectors.nav);
    const overlay = page.locator(shellSelectors.overlay);

    await expect(menuButton).toBeVisible();
    await expect(menuButton).toHaveAttribute('aria-controls', 'ms-app-navigation');
    await expect(menuButton).toHaveAttribute('aria-expanded', 'false');
    await expect(nav).toHaveAttribute('aria-hidden', 'true');

    await menuButton.click();

    await expect(page.locator(shellSelectors.shell)).toHaveClass(/ms-shell--menu-open/);
    await expect(nav).toHaveAttribute('aria-hidden', 'false');
    await expect(menuButton).toHaveAttribute('aria-expanded', 'true');
    await expect(overlay).toHaveClass(/is-open/);
  });

  test('closes menu by overlay click, navigation item, hamburger and Escape', async ({ page }) => {
    const menuButton = page.locator(shellSelectors.menuButton);

    await menuButton.click();

    const viewport = page.viewportSize();
    if (viewport) {
      await page.mouse.click(viewport.width - 10, 10);
    }

    await expect(page.locator(shellSelectors.shell)).not.toHaveClass(/ms-shell--menu-open/);

    await menuButton.click();
    await page.locator(shellSelectors.showcaseLink).click();
    await expect(page).toHaveURL(/\/showcase$/);
    await expect(page.locator(shellSelectors.shell)).not.toHaveClass(/ms-shell--menu-open/);

    await menuButton.click();
    await expect(page.locator(shellSelectors.shell)).toHaveClass(/ms-shell--menu-open/);
    await menuButton.click();
    await expect(page.locator(shellSelectors.shell)).not.toHaveClass(/ms-shell--menu-open/);

    await menuButton.click();
    await page.keyboard.press('Escape');
    await expect(page.locator(shellSelectors.shell)).not.toHaveClass(/ms-shell--menu-open/);
  });

  test('supports keyboard open and moves focus to nav panel', async ({ page }) => {
    const menuButton = page.locator(shellSelectors.menuButton);
    const nav = page.locator(shellSelectors.nav);

    await menuButton.focus();
    await page.keyboard.press('Enter');

    await expect(page.locator(shellSelectors.shell)).toHaveClass(/ms-shell--menu-open/);
    await expect(nav).toBeFocused();
  });
});
