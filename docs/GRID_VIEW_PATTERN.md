# Vista Tipo Grid — Patrón de Pantalla (v1)

## 1. Qué es una Vista Tipo Grid

La **Vista Tipo Grid** es una pantalla enterprise de trabajo orientada a operar datos en contexto. Su propósito es:

- listar registros,
- seleccionar uno o varios,
- ejecutar acciones laterales,
- mostrar detalle contextual,
- mantener una composición estable y predecible durante la operación.

Esta vista **no** es:

- una página de documentación,
- una demo de componentes,
- una página de cards.

Esta vista **sí** es una pantalla real de trabajo para flujos operativos.

---

## 2. Estructura general

La composición base de la vista se organiza en tres regiones:

- `LeftContent`
- `MiddleContent`
- `RightContent`

Lectura funcional de la pantalla:

- **Izquierda**: herramientas / acciones.
- **Centro**: grid principal.
- **Derecha**: detalle contextual.
- **Parte inferior del centro**: footer de estado (paginación/selección/status).

---

## 3. Rol de cada región

### 3.1 `LeftContent`

Rol esperado:

- barra lateral de acciones,
- ocupa todo el alto útil,
- utiliza `MxIconButton`,
- cada acción expone tooltip,
- se percibe como herramienta lateral (no como caja flotante),
- no domina visualmente sobre el grid.

### 3.2 `MiddleContent`

Rol esperado:

- región principal de trabajo,
- el grid es la pieza visual y funcional dominante,
- se divide en dos zonas:
  - área de grid,
  - footer del grid anclado al fondo.

### 3.3 `RightContent`

Rol esperado:

- panel de detalle contextual,
- sin selección: estado vacío o neutro,
- selección única: detalle real del registro,
- multiselección: representación agregada con `MultiValue` / `<Multiple values>`.

---

## 4. Comportamiento del grid

El grid se compone de tres zonas:

- **Header**
- **Filas**
- **Footer**

### 4.1 Header

- Fijo.
- Fondo sólido.
- No transparente.

### 4.2 Filas

- Área desplazable.
- Hacen scroll vertical.
- Ocupan el espacio central disponible entre header y footer.

### 4.3 Footer

- Fijo al fondo de `MiddleContent`.
- Siempre visible.
- No se desplaza con las filas.
- No forma parte del contenido scrollable.

---

## 5. Comportamiento con muchas filas

Con alto volumen de datos (por ejemplo, 500 filas), el comportamiento esperado se mantiene:

- el footer continúa fijo en la parte inferior,
- las filas hacen scroll,
- el header permanece fijo,
- el workspace no colapsa ni pierde estructura.

---

## 6. Estado de selección

Estados contemplados:

- **Sin selección**.
- **Selección única**.
- **Multiselección**.

Reglas de control:

- La selección se controla en la página consumidora, no en `MainContainer`.
- La franja inferior puede exponer estado operativo (ejemplo: `Selected: N`).
- `RightContent` cambia su contenido según la cantidad de seleccionados.

---

## 7. Reglas visuales

La Vista Tipo Grid:

- no debe parecer una demo técnica,
- no debe parecer una página de documentación,
- no debe parecer una página de tarjetas,
- debe percibirse como una herramienta real de trabajo,
- debe respetar el design system MachSoft.

---

## 8. Integración con el shell

Integración esperada:

- vive dentro del shell de aplicación,
- utiliza el workspace existente,
- puede requerir ajuste específico de padding en `.ms-shell__main`,
- cualquier ajuste debe ser específico de la vista y considerar responsive,
- no debe romper comportamiento ni layout de otras páginas.

---

## 9. Estado actual de la primera versión

### 9.1 Ya definido

- composición `LeftContent` / `MiddleContent` / `RightContent`,
- uso de `MainContainer`,
- uso de `MxDataGrid`,
- uso de `MxIconButton`,
- footer fijo,
- scroll en filas,
- detalle contextual,
- multiselección,
- soporte de `MultiValue`.

### 9.2 Pendiente de evolución

- variantes futuras del patrón,
- refinamientos visuales,
- paginación real,
- otros tipos de vista relacionados.

---

## 10. Alcance de esta documentación

Este documento fija la **v1** del patrón de pantalla Vista Tipo Grid tal como está definido actualmente en el proyecto. Cualquier cambio de comportamiento o contrato visual debe actualizar este archivo para mantener alineación entre diseño, desarrollo y adopción.
