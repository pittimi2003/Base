import type { Page } from '@playwright/test';

export async function waitForBlazorServerReady(page: Page): Promise<void> {
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
}
