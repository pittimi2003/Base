# Template Guide

## Arranque desde variante Server
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter`.
3. Validar rutas: `/`, `/showcase`, `/demo`.

## Arranque desde variante WASM
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter.Wasm`.
3. Validar rutas: `/`, `/showcase`, `/wasm-demo`.

## Contratos Foundation (API estable)
- `PageContainer`
  - `Title`, `Description`, `IsCompact`.
  - Usar como wrapper de primer nivel por página.
- `BaseCard`
  - `Title`, `BadgeText`, `Variant: SurfaceVariant`, `IsCompact`.
  - Usar `Variant` para intención visual; evitar combinar estilos ad-hoc.
- `AppMenuTile`
  - `Title`, `Description`, `Href`, `Icon`, `Variant: TileVariant`.
  - Usar para accesos de navegación/resumen, no para formularios.

## Base mínima de formularios
- `FormSection`: contenedor de bloque de formulario.
- `SectionTitle`: título + descripción de sección.
- `FieldGroup`: etiqueta, control y hint.

Uso recomendado:
1. `FormSection` dentro de `BaseCard`.
2. `FieldGroup` por campo.
3. Inputs nativos/controles locales dentro de `FieldGroup`.

## Reglas de composición
- `PageContainer + BaseCard` es la combinación por defecto para páginas de negocio.
- Usar `IsCompact=true` solo en subsecciones densas o anidadas.
- `SurfaceVariant.Outlined`: estructura/base neutral.
- `SurfaceVariant.Elevated`: destacar bloque prioritario.
- `SurfaceVariant.Muted`: contenido secundario o contexto.
- Promover a Foundation solo si el patrón se repite en Server y WASM y no contiene lógica de dominio.
- Mantener local al host/app si es específico del flujo de negocio.

## Governance Rules
- Todo cambio visual reusable pasa por `/showcase` antes de adopción.
- No aceptar componentes foundation sin:
  - API clara y mínima,
  - uso en showcase,
  - documentación en guía/arquitectura.
- Evitar duplicación entre Server y WASM: si se repite, mover a `Core`.

## Dónde tocar estilos globales
- Variables y escala: `tokens.css`.
- Tipografía/base: `base.css`.
- Shell y layout: `layout.css`.
- Componentes: `components.css`.
- Helpers: `utilities.css`.
