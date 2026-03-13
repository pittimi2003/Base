import type { Page } from '@playwright/test';
import { expect } from '@playwright/test';
import { shellSelectors } from './shell-selectors';

type BlazorReadyOptions = {
  requireMenuVisible?: boolean;
};

export async function waitForBlazorServerReady(page: Page, options: BlazorReadyOptions = {}): Promise<void> {
  const { requireMenuVisible = true } = options;
  const websocketPromise = page.waitForEvent(
    'websocket',
    (websocket) => websocket.url().includes('/_blazor?id='),
    { timeout: 45_000 }
  );

  await page.goto('/', { waitUntil: 'domcontentloaded' });
  await page.waitForResponse(
    (response) => response.url().includes('/_blazor/negotiate') && response.status() === 200,
    { timeout: 30_000 }
  );

  const websocket = await websocketPromise;
  await websocket.waitForEvent('framereceived', { timeout: 45_000 });

  const shell = page.locator(shellSelectors.interactiveShell);
  const menuButton = page.locator(shellSelectors.menuButton);

  await expect(shell).toBeVisible({ timeout: 30_000 });

  if (requireMenuVisible) {
    await expect(menuButton).toBeVisible({ timeout: 30_000 });
    await expect(menuButton).toBeEnabled({ timeout: 30_000 });
  }
}
