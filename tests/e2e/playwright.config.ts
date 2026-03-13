import path from 'path';
import { defineConfig } from '@playwright/test';

const PORT = process.env.E2E_PORT ?? '5010';
const baseURL = `http://127.0.0.1:${PORT}`;
const repoRoot = path.resolve(__dirname, '../..');

export default defineConfig({
  testDir: './tests',
  timeout: 60_000,
  expect: {
    timeout: 10_000
  },
  fullyParallel: true,
  retries: 0,
  reporter: [['list']],
  use: {
    baseURL,
    trace: 'on-first-retry'
  },
  webServer: {
    command: `dotnet run --project template/MachSoft.Template.Starter --urls ${baseURL}`,
    url: baseURL,
    cwd: repoRoot,
    reuseExistingServer: true,
    timeout: 120_000
  },
  projects: [
    {
      name: 'mobile',
      use: {
        browserName: 'chromium',
        viewport: { width: 390, height: 844 },
        isMobile: true,
        hasTouch: true
      }
    },
    {
      name: 'tablet',
      use: {
        browserName: 'chromium',
        viewport: { width: 834, height: 1112 },
        isMobile: true,
        hasTouch: true
      }
    },
    {
      name: 'desktop',
      use: {
        browserName: 'chromium',
        viewport: { width: 1440, height: 900 }
      }
    }
  ]
});
