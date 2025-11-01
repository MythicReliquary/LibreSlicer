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

Write-Host "Staging payload..."
New-Item -ItemType Directory -Force -Path ".\dist\bin" | Out-Null
if (Test-Path "$BuildDir\Release") { Copy-Item -Recurse -Force "$BuildDir\Release\*" ".\dist\bin\" }
elseif (Test-Path "$BuildDir") { Copy-Item -Recurse -Force "$BuildDir\*" ".\dist\bin\" }
if (Test-Path ".\resources") { Copy-Item -Recurse -Force ".\resources" ".\dist\" }
if (Test-Path ".\profiles") { Copy-Item -Recurse -Force ".\profiles" ".\dist\" }
if (Test-Path ".\licenses") { Copy-Item -Recurse -Force ".\licenses" ".\dist\" }

if (Test-Path ".\COMPLIANCE") {
  New-Item -ItemType Directory -Force -Path ".\dist\licenses" | Out-Null
  Copy-Item -Recurse -Force ".\COMPLIANCE\*" ".\dist\licenses\"
}

$exe = Get-ChildItem -Path "$BuildDir" -Recurse -Filter "*LibreSlicer*.exe" -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $exe) {
  $exe = Get-ChildItem -Path "$BuildDir" -Recurse -Filter "*.exe" | Where-Object { $_.Name -match "slicer" } | Select-Object -First 1
}
if ($exe) {
  Copy-Item $exe.FullName ".\dist\bin\LibreSlicer.exe" -Force
}

Write-Host "Packaging with NSIS..."
$env:LIBRESLICER_VERSION = (Get-Date -Format "yyyy.MM.dd.HHmm")
makensis /DVERSION=$env:LIBRESLICER_VERSION .\packaging\nsis\libreslicer.nsi
