# MachSoft.Template.Official

Template corporativo oficial para generar la app base MachSoft sobre ASP.NET Core 8, manteniendo el runtime reusable en `MachSoft.Template.Core` y empaquetando el bootstrap como template NuGet para `dotnet new install`.

## Estructura operativa
- `template/MachSoft.Template.Official/content/MachSoft.Template.App/` contiene exactamente la app base que generará `dotnet new machsoft-app`.
- `template/MachSoft.Template.Official.Pack/MachSoft.Template.Official.Pack.csproj` genera el paquete NuGet de tipo `Template`.
- `MachSoft.Template.Core` se distribuye como paquete NuGet separado y la app generada lo consume vía `PackageReference`.

## Empaquetar el template
```bash
dotnet pack template/MachSoft.Template.Official.Pack/MachSoft.Template.Official.Pack.csproj -c Release -o ./artifacts/templates
```

## Publicar en feed privado
```bash
dotnet nuget push ./artifacts/templates/MachSoft.Template.Official.1.0.0-internal.nupkg --source "<PRIVATE_FEED_URL>" --api-key "<API_KEY>"
```

## Instalar el template
```bash
dotnet new install ./artifacts/templates/MachSoft.Template.Official.1.0.0-internal.nupkg
```

## Generar una app nueva
```bash
dotnet new machsoft-app -n MyCompany.App -o ./MyCompany.App --CorePackageVersion 1.0.0-internal
```

## Actualizar a una nueva versión
1. Ajustar la versión compartida (`Version`) usada por el paquete del template.
2. Empaquetar nuevamente con `dotnet pack`.
3. Publicar la nueva versión con `dotnet nuget push`.
4. Reinstalar o actualizar localmente con `dotnet new install <ruta-o-paquete>`.

## Relación con MachSoft.Template.Core
- El template **no** embebe `MachSoft.Template.Core`.
- La app generada queda apuntando al paquete `MachSoft.Template.Core` para preservar la separación entre bootstrap de aplicación y runtime reusable compartido.
- Para compilar la app generada, el consumidor debe tener acceso al feed privado que publique `MachSoft.Template.Core`.
