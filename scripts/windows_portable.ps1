# Windows Portable Build for LibreSlicer
# Usage: Run from a VS 2022 Developer PowerShell
# Output: out/LibreSlicer_Portable_v1.0.0-beta.1.zip
param(
  [string]$Configuration = "Release",
  [string]$Version = "1.0.0-beta.1"
)

$ErrorActionPreference = 'Stop'
$Root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location (Resolve-Path "$Root/..")

$OutDir  = "out\win64"
$PkgRoot = "$OutDir\LibreSlicer_Portable_v$Version"
New-Item -ItemType Directory -Force -Path $OutDir  | Out-Null
New-Item -ItemType Directory -Force -Path $PkgRoot | Out-Null

# Configure
$buildDir = "build\win64"
New-Item -ItemType Directory -Force -Path $buildDir | Out-Null
cmake -S . -B $buildDir -G Ninja -DCMAKE_BUILD_TYPE=$Configuration -DLIBRESLICER_BRAND=ON

# Build
cmake --build $buildDir --config $Configuration --target all

# Locate binary (tolerates first-run target names)
$exe = Get-ChildItem -Recurse $buildDir -Filter *.exe | Where-Object { $_.Name -match 'LibreSlicer' } | Select-Object -First 1
if (-not $exe) { throw 'Could not find built exe; check CMake target name' }

# Stage files
Copy-Item $exe.FullName "$PkgRoot\libreslicer.exe" -Force
foreach ($f in @('LICENSE','NOTICE','SOURCE_OFFER','README.md')) {
  if (Test-Path $f) { Copy-Item $f $PkgRoot -Force }
}

# Zip
$zipPath = "out\LibreSlicer_Portable_v$Version.zip"
if (Test-Path $zipPath) { Remove-Item $zipPath -Force }
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::CreateFromDirectory($PkgRoot, $zipPath)
Write-Host "Created $zipPath"
