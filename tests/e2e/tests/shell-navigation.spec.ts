import { expect, test } from '@playwright/test';

const selectors = {
  shell: '.ms-shell',
  nav: '#ms-app-navigation',
  overlay: '#ms-shell-overlay',
  menuButton: '#ms-shell-menu-toggle',
  showcaseLink: '.ms-nav__item[href="/showcase"]',
  homeLink: '.ms-nav__item[href="/"]'
};

test.describe('AppShell responsive navigation', () => {
  test('mobile/tablet: menu toggle, overlay and close interactions', async ({ page }, testInfo) => {
    test.skip(testInfo.project.name === 'desktop', 'Desktop scenarios validated in dedicated desktop test.');

    await page.goto('/');

    const menuButton = page.locator(selectors.menuButton);
    const nav = page.locator(selectors.nav);
    const overlay = page.locator(selectors.overlay);

    await expect(menuButton).toBeVisible();
    await expect(menuButton).toHaveAttribute('aria-controls', 'ms-app-navigation');
    await expect(menuButton).toHaveAttribute('aria-expanded', 'false');
    await expect(nav).toHaveAttribute('aria-hidden', 'true');

    await menuButton.click();
    await expect(page.locator(selectors.shell)).toHaveClass(/ms-shell--menu-open/);
    await expect(nav).toHaveAttribute('aria-hidden', 'false');
    await expect(menuButton).toHaveAttribute('aria-expanded', 'true');
    await expect(overlay).toHaveClass(/is-open/);

    const viewport = page.viewportSize();
    if (viewport) {
      await page.mouse.click(viewport.width - 10, 10);
    }
    await expect(page.locator(selectors.shell)).not.toHaveClass(/ms-shell--menu-open/);
    await expect(menuButton).toHaveAttribute('aria-expanded', 'false');

    await menuButton.click();
    await page.locator(selectors.showcaseLink).click();
    await expect(page).toHaveURL(/\/showcase$/);
    await expect(page.locator(selectors.shell)).not.toHaveClass(/ms-shell--menu-open/);

    await menuButton.click();
    await expect(page.locator(selectors.shell)).toHaveClass(/ms-shell--menu-open/);
    await menuButton.click();
    await expect(page.locator(selectors.shell)).not.toHaveClass(/ms-shell--menu-open/);

    await menuButton.click();
    await page.keyboard.press('Escape');
    await expect(page.locator(selectors.shell)).not.toHaveClass(/ms-shell--menu-open/);

    await menuButton.focus();
    await page.keyboard.press('Enter');
    await expect(page.locator(selectors.shell)).toHaveClass(/ms-shell--menu-open/);
    await expect(nav).toBeFocused();
  });

  test('desktop: sidebar visible by default without overlay and navigation works', async ({ page }, testInfo) => {
    test.skip(testInfo.project.name !== 'desktop', 'Desktop-only assertions.');

    await page.goto('/');

    const menuButton = page.locator(selectors.menuButton);
    const nav = page.locator(selectors.nav);
    const overlay = page.locator(selectors.overlay);

    await expect(nav).toBeVisible();
    await expect(menuButton).toBeHidden();
    await expect(overlay).toBeHidden();

    await page.locator(selectors.showcaseLink).click();
    await expect(page).toHaveURL(/\/showcase$/);

    await page.locator(selectors.homeLink).click();
    await expect(page).toHaveURL(/\/$/);
  });
});
