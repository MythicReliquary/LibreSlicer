!include "MUI2.nsh"

!define APPNAME "LibreSlicer"
!ifndef VERSION
  !define VERSION "0.0.0-local"
!endif
!define COMPANY "Mythic Reliquary LLC"
!define INSTALLDIR "$PROGRAMFILES64\${APPNAME}"

Name "${APPNAME} ${VERSION}"
OutFile "LibreSlicer-${VERSION}.exe"
InstallDir "${INSTALLDIR}"
RequestExecutionLevel admin

!insertmacro MUI_PAGE_COMPONENTS
!insertmacro MUI_PAGE_DIRECTORY
!insertmacro MUI_PAGE_INSTFILES
!insertmacro MUI_LANGUAGE "English"

Section "LibreSlicer (required)"
  SectionIn RO
  SetOutPath "$INSTDIR"
  File /r "dist\bin\*.*"

  IfFileExists "dist\resources\*.*" 0 +2
    File /r "dist\resources\*.*"

  IfFileExists "dist\profiles\*.*" 0 +2
    File /r "dist\profiles\*.*"

  IfFileExists "dist\licenses\*.*" 0 +2
    File /r "dist\licenses\*.*"

  CreateShortcut "$SMPROGRAMS\LibreSlicer.lnk" "$INSTDIR\LibreSlicer.exe"
  CreateShortCut "$DESKTOP\LibreSlicer.lnk" "$INSTDIR\LibreSlicer.exe"
SectionEnd

Section "Uninstall"
  Delete "$SMPROGRAMS\LibreSlicer.lnk"
  Delete "$DESKTOP\LibreSlicer.lnk"
  RMDir /r "$INSTDIR"
SectionEnd
