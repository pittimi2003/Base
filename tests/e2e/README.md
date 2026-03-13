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

## Ejecución
> Los tests levantan automáticamente el host Server en `http://127.0.0.1:5010` usando `webServer` de Playwright.

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
```

## Escenarios cubiertos
### Mobile/Tablet
- hamburguesa visible y ARIA correcto;
- apertura de menú;
- overlay visible;
- cierre por overlay;
- cierre por item (`/showcase`);
- cierre por hamburguesa;
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
