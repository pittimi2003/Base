import { expect, test } from '@playwright/test';

type FamilySmokeCase = {
  route: string;
  heading: string;
  interact: (page: import('@playwright/test').Page) => Promise<void>;
};

const cases: FamilySmokeCase[] = [
  {
    route: '/families/actions',
    heading: 'Actions',
    interact: async (page) => {
      await page.getByRole('button', { name: 'Filled' }).first().click();
    }
  },
  {
    route: '/families/feedback',
    heading: 'Feedback',
    interact: async (page) => {
      await page.getByRole('button', { name: 'Mostrar toast éxito' }).click();
      await expect(page.getByText('Operación completada')).toBeVisible();
    }
  },
  {
    route: '/families/overlays',
    heading: 'Overlays',
    interact: async (page) => {
      await page.getByRole('button', { name: 'Abrir dialog' }).click();
      await expect(page.getByRole('dialog', { name: 'Aprobar publicación' })).toBeVisible();
      await page.getByRole('button', { name: 'Cancelar' }).click();
    }
  },
  {
    route: '/families/inputs',
    heading: 'Inputs',
    interact: async (page) => {
      await page.getByLabel('Título del incidente').fill('Incidente smoke e2e');
    }
  },
  {
    route: '/families/selection',
    heading: 'Selection',
    interact: async (page) => {
      await page.getByLabel('Búsqueda global').fill('Al');
      await expect(page.getByText('Alpha')).toBeVisible();
    }
  },
  {
    route: '/families/datetime',
    heading: 'DateTime',
    interact: async (page) => {
      await page.getByLabel('Fecha objetivo').fill('2026-03-26');
    }
  },
  {
    route: '/families/upload',
    heading: 'Upload',
    interact: async (page) => {
      await expect(page.getByLabel('Adjuntar archivos')).toBeVisible();
    }
  },
  {
    route: '/families/listing',
    heading: 'List / ListBox / Avatar / Chip',
    interact: async (page) => {
      await page.getByRole('button', { name: 'Seleccionar Alertas activas' }).click();
      await expect(page.getByText('Elemento seleccionado en MxList: alerts')).toBeVisible();
    }
  },
  {
    route: '/families/data',
    heading: 'Data',
    interact: async (page) => {
      await expect(page.locator('.mx-data-grid-scroll').first()).toBeVisible();
    }
  },
  {
    route: '/families/scheduling',
    heading: 'Scheduling',
    interact: async (page) => {
      await expect(page.locator('[data-testid="scheduler-base"]').first()).toBeVisible();
    }
  }
];

test.describe('Core.Control Showcase - smoke transversal por familias', () => {
  for (const familyCase of cases) {
    test(`smoke ${familyCase.route}`, async ({ page }) => {
      const runtimeErrors: string[] = [];

      page.on('pageerror', (error) => runtimeErrors.push(`pageerror:${error.message}`));
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

      await page.goto(familyCase.route, { waitUntil: 'domcontentloaded' });
      await page.waitForResponse(
        (response) => response.url().includes('/_blazor/negotiate') && response.status() === 200,
        { timeout: 30_000 }
      );
      const websocket = await websocketPromise;
      await websocket.waitForEvent('framereceived', { timeout: 45_000 });

      await expect(page.locator('.ms-showcase-page__header h1')).toContainText(familyCase.heading);
      await familyCase.interact(page);

      const themeSwitch = page.locator('#mx-showcase-theme-switch');
      await themeSwitch.scrollIntoViewIfNeeded();
      await themeSwitch.setChecked(true, { force: true });
      await expect(page.locator('.ms-control-shell')).toHaveAttribute('data-mx-theme', 'dark');
      await themeSwitch.setChecked(false, { force: true });
      await expect(page.locator('.ms-control-shell')).toHaveAttribute('data-mx-theme', 'light');

      expect(runtimeErrors, `Errores runtime detectados en ${familyCase.route}: ${runtimeErrors.join(' | ')}`).toEqual([]);
    });
  }
});
