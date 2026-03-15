# Fase 16 — Baseline operativa mínima (repetible)

## Para qué sirve
Responder de forma operativa:
1. Qué ejecutar para validar una release interna.
2. Qué ejecutar para validar una app nueva creada desde template.
3. Qué señales indican regresión clara.

## A) Baseline de release interna del sistema

### A.1 Comandos obligatorios
```bash
dotnet restore MachSoft.Template.sln
dotnet build MachSoft.Template.sln -c Release
dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o ./.artifacts/local-nuget
```

### A.2 Arranque hosts de validación
```bash
dotnet run --project template/MachSoft.Template.Starter --no-build -c Release
dotnet run --project template/MachSoft.Template.Starter.Wasm --no-build -c Release
```

### A.3 Smoke funcional mínimo
- Server: `/showcase` (light/dark) y `/demo`.
- WASM: `/showcase` (light/dark) y `/wasm-demo`.

## B) Baseline de app nueva generada

### B.1 Instalar template y crear app
```bash
dotnet new install ./template/MachSoft.Template.Official
dotnet new machsoft-app -n Contoso.App -o ./Contoso.App --CorePackageVersion 1.0.0-internal
```

### B.2 Restaurar/build/run
```bash
dotnet restore ./Contoso.App/Contoso.App.csproj
dotnet build ./Contoso.App/Contoso.App.csproj -c Release
dotnet run --project ./Contoso.App/Contoso.App.csproj --no-build -c Release
```

### B.3 Smoke de app generada
- Validar rutas: `/`, `/operations`, `/settings`.
- Confirmar carga de estilos tokenizados y shell corporativo.

## C) Consumo de paquete y feed

### C.1 Si el feed interno está disponible
- Publicar `MachSoft.Template.Core.<version>.nupkg` en feed corporativo.
- Consumir desde `PackageReference` en apps.

### C.2 Si el feed aún no está configurado
Usar feed local temporal con `nuget.config` del proyecto:

```xml
<?xml version="1.0" encoding="utf-8"?>
<configuration>
  <packageSources>
    <clear />
    <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
    <add key="MachSoftLocal" value="/ruta/al/directorio-con-nupkg" />
  </packageSources>
</configuration>
```

## D) Señales de regresión clara
- Restore o build Release falla en solución o app generada.
- `dotnet pack` no genera `.nupkg` y `.snupkg`.
- `dotnet new machsoft-app` falla o genera proyecto incompleto.
- App generada no levanta o rutas mínimas no responden.
- Rotura de shell responsive, tema light/dark o assets `_content`.
- Diferencia no documentada entre comportamiento Server y WASM.

## E) Resultado esperado de esta baseline
Si A+B+C+D se cumplen, el sistema queda **operable como plataforma interna** con circuito repetible de paquete + template + adopción de equipos.
