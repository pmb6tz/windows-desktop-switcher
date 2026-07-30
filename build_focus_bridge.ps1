[CmdletBinding()]
param()

$ErrorActionPreference = "Stop"

$vswhere = Join-Path ${env:ProgramFiles(x86)} "Microsoft Visual Studio\Installer\vswhere.exe"
if (-not (Test-Path $vswhere)) {
    throw "vswhere.exe was not found. Install Visual Studio Build Tools with the C++ workload."
}

$installationPath = & $vswhere -latest -products * `
    -requires Microsoft.VisualStudio.Component.VC.Tools.x86.x64 `
    -property installationPath
if (-not $installationPath) {
    throw "Visual Studio C++ build tools were not found."
}

$vcvars = Join-Path $installationPath "VC\Auxiliary\Build\vcvars64.bat"
$source = Join-Path $PSScriptRoot "DesktopFocusBridge.cpp"
$output = Join-Path $PSScriptRoot "DesktopFocusBridge.dll"
$object = Join-Path $PSScriptRoot "DesktopFocusBridge.obj"
$importLibrary = Join-Path $PSScriptRoot "DesktopFocusBridge.lib"
$exportsFile = Join-Path $PSScriptRoot "DesktopFocusBridge.exp"

$command = 'call "{0}" >nul && cl.exe /nologo /W4 /WX /O2 /GL /MT /EHsc /LD "{1}" /Fo"{2}" /link /LTCG /OPT:REF /OPT:ICF /Brepro ole32.lib user32.lib /OUT:"{3}"' -f `
    $vcvars, $source, $object, $output

& $env:ComSpec /d /s /c $command
if ($LASTEXITCODE -ne 0) {
    throw "DesktopFocusBridge build failed with exit code $LASTEXITCODE."
}

Remove-Item -LiteralPath $object, $importLibrary, $exportsFile -ErrorAction SilentlyContinue
Write-Host "Built $output"
