!include "MUI2.nsh"

!define APPNAME "AegisSlicer"
!ifndef VERSION
  !define VERSION "0.0.0-local"
!endif
!define COMPANY "Mythic Reliquary"
!define INSTALLDIR "$PROGRAMFILES64\${APPNAME}"

Name "${APPNAME} ${VERSION}"
OutFile "AegisSlicer-${VERSION}.exe"
InstallDir "${INSTALLDIR}"
RequestExecutionLevel admin

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "AegisSlicer (required)"
  SectionIn RO
  SetOutPath "$INSTDIR"
  File /r "dist\bin\*.*"

  # Resources / profiles if present
  IfFileExists "dist\resources\*.*" 0 +2
    File /r "dist\resources\*.*"

  IfFileExists "dist\profiles\*.*" 0 +2
    File /r "dist\profiles\*.*"

  IfFileExists "dist\licenses\*.*" 0 +2
    File /r "dist\licenses\*.*"

  CreateShortcut "$SMPROGRAMS\AegisSlicer.lnk" "$INSTDIR\AegisSlicer.exe"
  CreateShortCut "$DESKTOP\AegisSlicer.lnk" "$INSTDIR\AegisSlicer.exe"
SectionEnd

Section "Uninstall"
  Delete "$SMPROGRAMS\AegisSlicer.lnk"
  Delete "$DESKTOP\AegisSlicer.lnk"
  RMDir /r "$INSTDIR"
SectionEnd