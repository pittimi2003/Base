import path from 'path';
import { defineConfig } from '@playwright/test';

const PORT = process.env.E2E_PORT ?? '5010';
const baseURL = `http://127.0.0.1:${PORT}`;
const repoRoot = path.resolve(__dirname, '../..');

export default defineConfig({
  testDir: './tests',
  timeout: 60_000,
  globalTimeout: 12 * 60_000,
  expect: {
    timeout: 20_000
  },
  fullyParallel: false,
  workers: process.env.CI ? 1 : undefined,
  retries: 0,
  reporter: process.env.CI ? [['line']] : [['list']],
  use: {
    baseURL,
    headless: true,
    trace: 'on-first-retry',
    launchOptions: {
      args: ['--no-sandbox', '--disable-dev-shm-usage']
    }
  },
  webServer: {
    command: `dotnet build template/MachSoft.Template.Starter/MachSoft.Template.Starter.csproj && dotnet run --no-build --project template/MachSoft.Template.Starter --urls ${baseURL}`,
    url: baseURL,
    cwd: repoRoot,
    reuseExistingServer: false,
    timeout: 240_000,
    stdout: 'pipe',
    stderr: 'pipe'
  },
  projects: [
    {
      name: 'mobile',
      testMatch: ['**/shell-mobile-tablet.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 390, height: 844 },
        isMobile: true,
        hasTouch: true
      }
    },
    {
      name: 'tablet',
      testMatch: ['**/shell-mobile-tablet.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 834, height: 1112 },
        isMobile: true,
        hasTouch: true
      }
    },
    {
      name: 'desktop',
      testMatch: ['**/shell-desktop.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 1440, height: 900 }
      }
    }
  ]
});
