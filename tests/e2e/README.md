# MachSoft.Template E2E (Playwright)

Suite E2E enfocada en regresiones del `AppShell` responsive.

## Prerrequisitos
- Node.js **18+** (recomendado 20 LTS).
- .NET SDK (para levantar `template/MachSoft.Template.Starter`).
- Acceso de red a CDN de Playwright **o** mirror interno para descargar navegadores.

## Instalación local
```bash
cd tests/e2e
npm install
npm run install:browsers
```

> Si `playwright: not found`, falta ejecutar `npm install` en `tests/e2e`.

## Ejecución
> Los tests levantan automáticamente el host Server usando `webServer` de Playwright.
> Scripts principales usan puertos dedicados para evitar colisiones en runner compartido:
> - `test`: 5010
> - `test:mobile`: 5110
> - `test:desktop`: 5111
> - `test:ci`: 5120
> - todos ejecutan `cleanup:hosts` (`scripts/cleanup-hosts.sh`) antes de iniciar para limpiar procesos previos.

La configuración está endurecida para contenedor/CI con:
- `headless: true`;
- `launchOptions.args`: `--no-sandbox`, `--disable-dev-shm-usage`;
- `webServer.timeout` ampliado a 180s;
- `reuseExistingServer: false` para forzar host limpio por corrida;
- `expect.timeout` en 20s;
- espera explícita de handshake Blazor Server (`/_blazor/negotiate` + websocket `/_blazor?id=...`) antes de interacciones para evitar flakiness en `@onclick`.
- señal de readiness del shell vía `data-ms-shell-interactive="true"` para asegurar que el layout ya está interactivo antes de clicar hamburguesa.

Además, el `webServer.command` ejecuta `dotnet build` + `dotnet run --no-build` para reducir variabilidad de arranque en contenedor/CI.

```bash
# todas las pruebas
npm test

# subset por dispositivo
npm run test:mobile
npm run test:desktop

# modos de depuración
npm run test:headed
npm run test:ui
npm run test:debug

# comando recomendado para CI si el runner no cachea browsers
npm run test:ci:prepared
```

## Escenarios cubiertos
### Mobile/Tablet
- hamburguesa visible y ARIA correcto;
- apertura de menú;
- overlay visible;
- cierre por overlay;
- cierre por item (`/showcase`);
- cierre por `Escape`;
- apertura por teclado y foco movido a panel de navegación.

### Desktop
- sidebar fijo visible por defecto;
- overlay no visible;
- hamburguesa no visible;
- navegación lateral funcional entre `/`, `/showcase` y `/demo`.

## Restricciones de red / alternativa mirror
Si `npm run install:browsers` falla por bloqueo CDN:
- definir un mirror interno compatible con Playwright mediante `PLAYWRIGHT_DOWNLOAD_HOST`;
- o preinstalar binarios y compartir `PLAYWRIGHT_BROWSERS_PATH` en el equipo/runner.

Observación de este runner: la URL primaria `cdn.playwright.dev` puede responder 403 (`Domain forbidden`), pero la URL fallback de Microsoft (`playwright.download.prss.microsoft.com`) puede completar la descarga.

Ejemplo:
```bash
export PLAYWRIGHT_BROWSERS_PATH=$HOME/.cache/ms-playwright
export PLAYWRIGHT_DOWNLOAD_HOST=https://<mirror-interno-playwright>
npm run install:browsers
```

## Recomendación mínima para CI
- Cachear `~/.cache/ms-playwright` (o el path definido en `PLAYWRIGHT_BROWSERS_PATH`).
- Ejecutar:
```bash
cd tests/e2e
npm ci
npm run install:browsers
npm run test:ci
```
- Si existe mirror corporativo, exportar `PLAYWRIGHT_DOWNLOAD_HOST` para evitar dependencia directa de CDN pública.

## Diagnóstico rápido de fallos comunes
- `playwright: not found`: falta `npm install` en `tests/e2e`.
- `Executable doesn't exist at ...chromium_headless_shell...`: browsers no instalados (ejecutar `npm run install:browsers`).
- timeout en `webServer`: validar que `dotnet run --project template/MachSoft.Template.Starter --urls http://127.0.0.1:5010` levante y responda.

## Causa de inestabilidad mobile resuelta
- La señal previa (`negotiate` + primer frame websocket) podía llegar antes de que el shell quedara listo para interacción efectiva en mobile.
- Ahora la suite espera además `data-ms-shell-interactive="true"` + hamburguesa visible/habilitada para reducir fallos por timing prematuro.

## Premium visual preview (SampleApp)

Para validación visual reproducible de `MachSoft.Template.CorePremium`:

```bash
./scripts/bootstrap-env.sh
./scripts/run-premium-preview-check.sh
```

Esto ejecuta Playwright sobre `samples/MachSoft.Template.SampleApp`, abre `/premium-showcase` y genera screenshots en:

- `artifacts/ui-preview/premium-01-landing.png`
- `artifacts/ui-preview/premium-02-forms.png`
- `artifacts/ui-preview/premium-03-data.png`
- `artifacts/ui-preview/premium-04-overlays.png`

La verificación falla si no se generan evidencias visuales (`*.png`).
