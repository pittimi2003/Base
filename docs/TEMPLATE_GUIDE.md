# Template Guide

## Arranque desde variante Server
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter`.
3. Validar rutas: `/`, `/showcase`, `/demo`.

## Arranque desde variante WASM
1. Abrir `MachSoft.Template.sln`.
2. Ejecutar `template/MachSoft.Template.Starter.Wasm`.
3. Validar rutas: `/`, `/showcase`, `/wasm-demo`.

## Cómo crear componentes compartidos
- Crear componentes reutilizables en `src/MachSoft.Template.Core/Components/Foundation`.
- Mantener APIs simples por parámetros.
- Evitar dependencias de negocio o de runtime específico (Server/WASM) en Core.

## Dónde tocar estilos globales
- Variables y colores: `tokens.css`.
- Tipografía/base: `base.css`.
- Shell: `layout.css`.
- Componentes: `components.css`.
- Helpers: `utilities.css`.

## Extender sin romper arquitectura
- Cambios cross-host: siempre en `MachSoft.Template.Core`.
- Cambios exclusivos Server: solo en `MachSoft.Template.Starter`.
- Cambios exclusivos WASM: solo en `MachSoft.Template.Starter.Wasm`.
- Si aparece lógica de dominio, crear proyecto de aplicación separado y consumir Core.
