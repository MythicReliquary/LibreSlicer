<#
.SYNOPSIS
    Smoke-test LibreSlicer GUI using PowerShell automation.

.DESCRIPTION
    Launches LibreSlicer.exe, waits for the splash screen, opens a sample model,
    slices, exports, and then collects the log file. Requires Windows and the
    Windows Script Host `WScript.Shell` sendkeys functionality.

.PARAMETER ExePath
    Path to libreslicer.exe (default: ..\build\src\libreslicer.exe)

.PARAMETER ModelPath
    Sample model to load (default: resources\data\embossed_text.obj)

.PARAMETER LogOutput
    Directory where prusa-slicer.log will be copied
#>

param(
    [string]$ExePath = "..\build\src\libreslicer.exe",
    [string]$ModelPath = "..\resources\data\embossed_text.obj",
    [string]$LogOutput = "..\artifacts\gui-test"
)
# Ensure log directory exists for redirection scenarios
if (-not (Test-Path $LogOutput)) {
    New-Item -ItemType Directory -Force -Path $LogOutput | Out-Null
}

function Wait-UntilIdle {
    param([int]$Seconds = 5)
    Start-Sleep -Seconds $Seconds
}

function Activate-LibreSlicerWindow {
    param([System.Diagnostics.Process]$Process, [int]$TimeoutSec = 20)
    $shell = New-Object -ComObject "WScript.Shell"
    $elapsed = 0
    while ($elapsed -lt $TimeoutSec) {
        $Process.Refresh()
        if ($Process.MainWindowHandle -ne 0) {
            $title = $Process.MainWindowTitle
            if ($title) {
                $shell.AppActivate($title) | Out-Null
                return $true
            }
        }
        Start-Sleep -Milliseconds 500
        $elapsed += 0.5
    }
    Write-Warning "Failed to activate LibreSlicer window; keystrokes may go elsewhere."
    return $false
}

function Send-Keys {
    param([string]$Keys)
    $shell = New-Object -ComObject "WScript.Shell"
    $shell.SendKeys($Keys)
    Start-Sleep -Milliseconds 500
}

Write-Host "[INFO] Launching $ExePath"
$proc = Start-Process -FilePath (Resolve-Path $ExePath) -PassThru -WindowStyle Normal
try {
    Write-Host "[INFO] Waiting for splash…" 
    Wait-UntilIdle -Seconds 10
    Activate-LibreSlicerWindow -Process $proc | Out-Null

    Write-Host "[INFO] Opening sample model $ModelPath"
    Send-Keys "^o"            # Ctrl+O
    Start-Sleep -Milliseconds 500
    Send-Keys ("{F6}{HOME}" + (Resolve-Path $ModelPath).Path)
    Send-Keys "{ENTER}"
    Wait-UntilIdle -Seconds 5

    Write-Host "[INFO] Slicing (Ctrl+G)…"
    Send-Keys "^g"
    Wait-UntilIdle -Seconds 10

    Write-Host "[INFO] Exporting (Ctrl+S)…"
    Send-Keys "^s"
    Start-Sleep -Milliseconds 500
    $outPath = (Resolve-Path $ModelPath).Path.Replace(".obj", ".gcode")
    Send-Keys ("{F6}{HOME}" + $outPath)
    Send-Keys "{ENTER}"
    Wait-UntilIdle -Seconds 3
}
finally {
    Write-Host "[INFO] Closing LibreSlicer"
    try {
        Stop-Process -Id $proc.Id -Force -ErrorAction Stop
    }
    catch [System.Management.Automation.RuntimeException] {
        Write-Warning "LibreSlicer process already exited."
    }
}

$logPath = Join-Path $env:APPDATA "LibreSlicer\print\prusa-slicer.log"
if (Test-Path $logPath) {
    $destDir = Resolve-Path $LogOutput
    $dest = Join-Path $destDir "libreslicer.log"
    Copy-Item $logPath $dest -Force
    Write-Host "[INFO] Log copied to $dest"
}
else {
    Write-Warning "Log file not found at $logPath"
}
