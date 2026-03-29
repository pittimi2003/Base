# Runtime Certification — Templates Server/Wasm

Date (UTC): 2026-03-29

## Scope
Certification of **real projects generated from templates** after Core/Control migration cleanup:

- Server template (`machsoft-server`)
- WebAssembly template (`machsoft-wasm`)

Validated: restore, build, runtime startup, shell render entrypoint, Core/Control assets, and absence of runtime contract errors (e.g., `ShowFooter`).

## Generation from templates
Templates discovered from:

- `src/MachSoft.Template.Official.Server/template-content/.template.config/template.json` (`shortName: machsoft-server`)
- `src/MachSoft.Template.Official.Wasm/template-content/.template.config/template.json` (`shortName: machsoft-wasm`)

Commands used:

```bash
dotnet new install ./src/MachSoft.Template.Official.Server/template-content
dotnet new install ./src/MachSoft.Template.Official.Wasm/template-content

dotnet new machsoft-server -n RuntimeCertServer
dotnet new machsoft-wasm -n RuntimeCertWasm
```

## NuGet source handling used for this certification
Generated templates reference package IDs `MachSoft.Template.Core` and `MachSoft.Template.Core.Control`.

For this environment, those packages are not on nuget.org; therefore a local feed was created by packing the current repo projects:

```bash
dotnet pack src/MachSoft.Template.Core/MachSoft.Template.Core.csproj -c Release -o /tmp/ms-runtime-cert/local-feed -p:RestoreSources=https://api.nuget.org/v3/index.json
dotnet pack src/MachSoft.Template.Core.Control/MachSoft.Template.Core.Control.csproj -c Release -o /tmp/ms-runtime-cert/local-feed -p:RestoreSources=https://api.nuget.org/v3/index.json
```

Then restores used:

```bash
dotnet restore -s /tmp/ms-runtime-cert/local-feed -s https://api.nuget.org/v3/index.json
```

## Runtime validation executed

### Server (`RuntimeCertServer`)
1. Restore OK
2. Build OK (`Release`)
3. Run OK (`dotnet run -c Release --no-build --no-launch-profile`)
4. Startup log contains:
   - `Now listening on: http://127.0.0.1:5191`
   - `Application started`
5. Home page responded `200`.
6. Parsed all `_content/...` Core/Control CSS/JS links rendered by `MxControlAssets` and requested each asset.
7. All validated assets returned `200`:
   - `_content/MachSoft.Template.Core/css/machsoft-template-core.css`
   - `_content/MachSoft.Template.Core.Control/css/machsoft-template-core-control.css`
   - Core design-system token/theme/layout/component files under `_content/MachSoft.Template.Core/css/template/...`
   - `_content/MachSoft.Template.Core/js/theme.js`
8. No runtime exception found in server log; no `ShowFooter` contract error observed.

### Wasm (`RuntimeCertWasm`)
1. Restore OK
2. Build OK (`Release`)
3. Run OK (`dotnet run -c Release --no-build --no-launch-profile`)
4. Startup log contains:
   - `Now listening on: http://127.0.0.1:5192`
   - `Application started`
5. Home page responded `200`.
6. Requested essential assets referenced in `index.html`:
   - `_content/MachSoft.Template.Core/css/machsoft-template-core.css`
   - `_content/MachSoft.Template.Core.Control/css/machsoft-template-core-control.css`
   - `_content/MachSoft.Template.Core/js/theme.js`
   - `_framework/blazor.webassembly.js`
7. All returned `200`.
8. No runtime exception found in wasm host log; no `ShowFooter` contract error observed.

## Migration residue status (runtime)
- No functional residue observed at runtime from Core/Control migration.
- Server and Wasm generated projects run correctly and resolve Core/Control assets.
- Shell/home load validated through successful document fetch and asset resolution.

## Notes
- Running Server in `Production` without static web assets bootstrap can show `_content` 404 in local CLI run; certification run used `Development` (standard local template runtime validation path) and confirmed all required assets are served.
