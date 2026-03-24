import path from 'path';
import { defineConfig } from '@playwright/test';

const PORT = process.env.E2E_PORT ?? '5010';
const baseURL = `http://127.0.0.1:${PORT}`;
const repoRoot = path.resolve(__dirname, '../..');
const previewMode = process.env.E2E_PREVIEW === '1';

const starterCommand = `dotnet build template/MachSoft.Template.Starter/MachSoft.Template.Starter.csproj && dotnet run --no-build --project template/MachSoft.Template.Starter --urls ${baseURL}`;
const sampleCommand = `ASPNETCORE_ENVIRONMENT=Development dotnet build samples/MachSoft.Template.SampleApp/MachSoft.Template.SampleApp.csproj && ASPNETCORE_ENVIRONMENT=Development dotnet run --no-build --project samples/MachSoft.Template.SampleApp/MachSoft.Template.SampleApp.csproj --urls ${baseURL}`;

export default defineConfig({
  testDir: '.',
  timeout: 60_000,
  globalTimeout: 15 * 60_000,
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
    command: previewMode ? sampleCommand : starterCommand,
    url: baseURL,
    cwd: repoRoot,
    reuseExistingServer: false,
    timeout: 300_000,
    stdout: 'pipe',
    stderr: 'pipe'
  },
  projects: [
    {
      name: 'mobile',
      testMatch: ['tests/shell-mobile-tablet.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 390, height: 844 },
        isMobile: true,
        hasTouch: true
      }
    },
    {
      name: 'tablet',
      testMatch: ['tests/shell-mobile-tablet.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 834, height: 1112 },
        isMobile: true,
        hasTouch: true
      }
    },
    {
      name: 'desktop',
      testMatch: ['tests/shell-desktop.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 1440, height: 900 }
      }
    },
    {
      name: 'preview',
      testMatch: ['preview.spec.ts'],
      use: {
        browserName: 'chromium',
        viewport: { width: 1600, height: 1100 }
      }
    }
  ]
});
