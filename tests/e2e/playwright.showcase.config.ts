import path from 'path';
import { defineConfig } from '@playwright/test';

const PORT = process.env.E2E_SHOWCASE_PORT ?? '5135';
const baseURL = `http://127.0.0.1:${PORT}`;
const repoRoot = path.resolve(__dirname, '../..');

export default defineConfig({
  testDir: './tests',
  testMatch: ['**/families-data-grid.spec.ts'],
  timeout: 75_000,
  expect: {
    timeout: 20_000
  },
  fullyParallel: false,
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
    command: `dotnet build src/MachSoft.Template.Core.Control.Showcase/MachSoft.Template.Core.Control.Showcase.csproj && dotnet run --no-build --project src/MachSoft.Template.Core.Control.Showcase --urls ${baseURL}`,
    url: baseURL,
    cwd: repoRoot,
    reuseExistingServer: false,
    timeout: 240_000,
    stdout: 'pipe',
    stderr: 'pipe'
  },
  projects: [
    {
      name: 'desktop',
      use: {
        browserName: 'chromium',
        viewport: { width: 1440, height: 900 }
      }
    }
  ]
});
