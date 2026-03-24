# MachSoft.Template.Core.Control

Catálogo oficial de controles `Mx*` para MachSoft sobre Blazor.

## Propósito
- Exponer contratos públicos de catálogo listos para consumo por aplicaciones Server y WebAssembly.
- Reutilizar la base de design system desde `MachSoft.Template.Core` sin acoplar lógica de negocio.
- Distribuirse como paquete NuGet interno con static web assets.

## Uso rápido
1. Referenciar el paquete `MachSoft.Template.Core.Control`.
2. Incluir estilos:
   - `_content/MachSoft.Template.Core/css/machsoft-template-core.css`
   - `_content/MachSoft.Template.Core.Control/css/machsoft-template-core-control.css`
3. Configurar tema con `data-mx-theme="light|dark"` en el contenedor raíz.
