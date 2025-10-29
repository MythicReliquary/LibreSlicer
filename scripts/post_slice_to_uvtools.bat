@echo off
setlocal
set UVTOOLS_EXE="%ProgramFiles%\UVTools\UVtools.exe"
if not exist %UVTOOLS_EXE% (
  echo UVtools.exe not found in default location. Please install UVTools or edit this script.
  pause & exit /b 1
)
rem %1 can be a cbddlp/png folder; adjust if you want to pass the current project
start "" %UVTOOLS_EXE%
endlocal
