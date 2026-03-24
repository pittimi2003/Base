import fs from 'fs';
import path from 'path';
import { test, expect, type Page } from '@playwright/test';

const outputDir = path.resolve(__dirname, '../../artifacts/ui-preview');

async function shot(page: Page, name: string) {
  await fs.promises.mkdir(outputDir, { recursive: true });
  const filePath = path.join(outputDir, `${name}.png`);
  await page.screenshot({ path: filePath, fullPage: true });
}

test.describe('Premium visual preview evidence', () => {
  test('captures reproducible screenshots for /premium-showcase', async ({ page }) => {
    await page.goto('/premium-showcase', { waitUntil: 'networkidle' });

    const coreCss = await page.request.get('/_content/MachSoft.Template.Core/css/machsoft-template-core.css');
    const premiumCss = await page.request.get('/_content/MachSoft.Template.CorePremium/css/machsoft-template-corepremium.css');
    expect(coreCss.ok()).toBeTruthy();
    expect(premiumCss.ok()).toBeTruthy();

    await expect(page.locator('.ms-premium-page-header')).toBeVisible();
    await expect(page.locator('.ms-premium-breadcrumbs')).toBeVisible();
    await expect(page.locator('.ms-premium-tabs')).toBeVisible();
    await expect(page.locator('.ms-premium-toolbar-shell')).toBeVisible();

    await shot(page, 'premium-01-landing');

    await page.locator('#premium-forms').scrollIntoViewIfNeeded();
    await expect(page.locator('text=Formularios premium')).toBeVisible();
    await expect(page.locator('text=Estrategia de despacho')).toBeVisible();
    await expect(page.locator('text=Adjuntos de evidencia')).toBeVisible();
    await shot(page, 'premium-02-forms');

    await page.locator('#premium-data').scrollIntoViewIfNeeded();
    await expect(page.locator('text=Data grid premium')).toBeVisible();
    await expect(page.locator('text=Lista premium de alertas')).toBeVisible();
    await shot(page, 'premium-03-data');

    await expect(page.getByRole('dialog')).toBeVisible();
    await expect(page.locator('.ms-premium-toast')).toBeVisible();
    await shot(page, 'premium-04-overlays');

    const files = fs.readdirSync(outputDir).filter(file => file.endsWith('.png'));
    expect(files.length).toBeGreaterThanOrEqual(4);
  });
});
