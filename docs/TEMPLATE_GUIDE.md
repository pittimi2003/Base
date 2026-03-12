# Template Guide

## Arranque desde variante Server
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter`.
3. Validar rutas: `/`, `/showcase`, `/demo`.

## Arranque desde variante WASM
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter.Wasm`.
3. Validar rutas: `/`, `/showcase`, `/wasm-demo`.

## Reglas de layout
- `MainLayout` solo orquesta; no concentrar lógica visual extensa.
- Usar subcomponentes del shell (`AppShell`, `AppHeader`, `AppNavigation`, `AppFooter`) para cambios de estructura.
- Mantener layout host-agnostic dentro de `Core`.

## Componentes foundation y variantes
- `PageContainer`: wrapper principal por página (`Compact` opcional).
- `BaseCard`: `Variant=default|elevated|outlined|muted`, `Compact=true|false`.
- `AppMenuTile`: `Variant=default|elevated|muted`.

## Dónde tocar estilos globales
- Variables y escala: `tokens.css`.
- Tipografía/base: `base.css`.
- Shell y layout: `layout.css`.
- Componentes: `components.css`.
- Helpers: `utilities.css`.

## Extender sin romper arquitectura
- Cambios cross-host: siempre en `MachSoft.Template.Core`.
- Cambios exclusivos Server: solo en `MachSoft.Template.Starter`.
- Cambios exclusivos WASM: solo en `MachSoft.Template.Starter.Wasm`.
- Si aparece lógica de dominio, crear proyecto de aplicación separado y consumir Core.

## Showcase como catálogo
Mantener `/showcase` como catálogo minimalista del design system:
- tipografía,
- spacing/tokens,
- variantes de foundation components,
- navegación base.
