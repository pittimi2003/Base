# MachSoft.Template.Core

Paquete NuGet reusable del MachSoft Design System para Blazor Server y Blazor WebAssembly.

## Incluye
- Componentes `Mx*` (Foundation, Forms, Navigation/Overlays, Data display, Inputs, Data).
- Layout reusable (`MainLayout` y shell `AppShell/AppHeader/AppNavigation/AppFooter`).
- Tokens y estilos estáticos en `_content/MachSoft.Template.Core/css/template/*`.
- Script de tema en `_content/MachSoft.Template.Core/js/theme.js`.

## No incluye
- Hosts de arranque (`template/MachSoft.Template.Starter*`).
- Aplicaciones de ejemplo (`samples/*`).
- Configuración de dominio o infraestructura de negocio.

## Consumo interno mínimo
1. Agregar referencia al paquete `MachSoft.Template.Core`.
2. Registrar `@using MachSoft.Template.Core.Components.Foundation` (o namespaces `Mx*` necesarios).
3. Incluir assets de Core en el host:
   - `_content/MachSoft.Template.Core/css/template/tokens.css`
   - `_content/MachSoft.Template.Core/css/template/base.css`
   - `_content/MachSoft.Template.Core/css/template/layout.css`
   - `_content/MachSoft.Template.Core/css/template/components.css`
   - `_content/MachSoft.Template.Core/css/template/utilities.css`
   - `_content/MachSoft.Template.Core/js/theme.js`
4. Consumir componentes (`MxCard`, `MxButton`, `MxPageHeader`, etc.) y/o layout compartido.

## Limitaciones actuales
- El paquete mantiene páginas de soporte de plantilla (`/` y `/showcase`) para validación interna, pero no incluye samples/hosts.
- Evolución de template corporativo se gestiona en fase siguiente.
