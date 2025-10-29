# Usage: powershell -ExecutionPolicy Bypass -File .\scripts\build_win_release.ps1
param(
  [string]$BuildDir = "build",
  [switch]$Clean
)

$ErrorActionPreference = "Stop"

if ($Clean) {
  if (Test-Path $BuildDir) { Remove-Item -Recurse -Force $BuildDir }
  if (Test-Path "dist") { Remove-Item -Recurse -Force "dist" }
}

# Ensure MSVC env is loaded if running from plain PS
# In GitHub Actions this is provided by ilammy/msvc-dev-cmd
Write-Host "Configuring (Release, x64)..."

$toolchain = ""
if (Test-Path ".\vcpkg\scripts\buildsystems\vcpkg.cmake") {
  $toolchain = "-DCMAKE_TOOLCHAIN_FILE=.\vcpkg\scripts\buildsystems\vcpkg.cmake"
}

cmake -S . -B $BuildDir -G "Ninja" -DCMAKE_BUILD_TYPE=Release `
  -DSLIC3R_STATIC=ON -DENABLE_SLA=ON -DUSE_OPENVDB=ON `
  $toolchain

Write-Host "Building..."
cmake --build $BuildDir --config Release --parallel

# Stage files for NSIS
Write-Host "Staging..."
New-Item -ItemType Directory -Force -Path ".\dist\bin" | Out-Null
if (Test-Path "$BuildDir\Release") { Copy-Item -Recurse -Force "$BuildDir\Release\*" ".\dist\bin\" }
elseif (Test-Path "$BuildDir") { Copy-Item -Recurse -Force "$BuildDir\*" ".\dist\bin\" }
if (Test-Path ".\resources") { Copy-Item -Recurse -Force ".\resources" ".\dist\" }
if (Test-Path ".\profiles") { Copy-Item -Recurse -Force ".\profiles" ".\dist\" }
if (Test-Path ".\licenses") { Copy-Item -Recurse -Force ".\licenses" ".\dist\" }

# Include AGPL source-offer inside installer payload
if (Test-Path ".\COMPLIANCE") {
  New-Item -ItemType Directory -Force -Path ".\dist\licenses" | Out-Null
  Copy-Item -Recurse -Force ".\COMPLIANCE\*" ".\dist\licenses\"
}

# (If not already present above) Normalize EXE name for installer
if (-not (Test-Path ".\dist\bin\AegisSlicer.exe")) {
  $exe = Get-ChildItem -Path "$BuildDir" -Recurse -Filter "*AegisSlicer*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
  if (-not $exe) { $exe = Get-ChildItem -Path "$BuildDir" -Recurse -Filter "*.exe" | Where-Object { $_.Name -match "slicer" } | Select-Object -First 1 }
  if ($exe) { Copy-Item $exe.FullName ".\dist\bin\AegisSlicer.exe" -Force }
}

# Normalize the main EXE name for the installer (AegisSlicer.exe)
$exe = Get-ChildItem -Path "$BuildDir" -Recurse -Filter "*AegisSlicer*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exe) {
  $exe = Get-ChildItem -Path "$BuildDir" -Recurse -Filter "*.exe" | Where-Object { $_.Name -match "slicer" } | Select-Object -First 1
}
if ($exe) {
  Copy-Item $exe.FullName ".\dist\bin\AegisSlicer.exe" -Force
}

# Build installer
Write-Host "Packaging with NSIS..."
$env:AEGIS_VERSION = (Get-Date -Format "yyyy.MM.dd.HHmm")
makensis /DVERSION=$env:AEGIS_VERSION .\packaging\nsis\aegis.nsi