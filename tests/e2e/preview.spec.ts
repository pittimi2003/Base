import { test, expect } from '@playwright/test';
import fs from 'fs';
import path from 'path';

const baseUrl = process.env.BASE_URL ?? 'http://127.0.0.1:52922';
const artifactsDir = process.env.ARTIFACTS_DIR ?? 'artifacts/ui-preview';

function ensureArtifactsDir() {
  fs.mkdirSync(artifactsDir, { recursive: true });
}

test.describe('MachSoft Premium Preview', () => {
  test('premium showcase should render and produce screenshots', async ({ page }) => {
    ensureArtifactsDir();

    await page.goto(`${baseUrl}/premium-showcase`, { waitUntil: 'networkidle' });

    await expect(page).toHaveURL(/premium-showcase/);
    await expect(page.locator('body')).toBeVisible();

    await page.setViewportSize({ width: 1600, height: 2400 });

    await page.screenshot({
      path: path.join(artifactsDir, 'premium-showcase-full.png'),
      fullPage: true
    });

    await expect(page.locator('text=Premium')).toBeVisible();
  });

  test('home should render and produce screenshots', async ({ page }) => {
    ensureArtifactsDir();

    await page.goto(`${baseUrl}/`, { waitUntil: 'networkidle' });

    await expect(page.locator('body')).toBeVisible();

    await page.setViewportSize({ width: 1600, height: 1400 });

    await page.screenshot({
      path: path.join(artifactsDir, 'home-full.png'),
      fullPage: true
    });
  });
});