Windows Registry Editor Version 5.00

; @ECHO OFF
; CLS
; ECHO OneDrive Closing...
; taskkill /f /im OneDrive.exe
; ECHO OneDrive Uninstalling...
; if %PROCESSOR_ARCHITECTURE%==x86 (
;	%SystemRoot%\System32\OneDriveSetup.exe /uninstall
; ) else (
;	%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
; )
; REGEDIT.EXE /S "%~f0"
; ECHO OneDrive Panel Removed...
; ECHO OneDrive Uninstalled! If you wish to reinstall it run "%SystemRoot%\SysWOW64\OneDriveSetup.exe".
; PAUSE
; EXIT

[-HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]

[-HKEY_CLASSES_ROOT\WOW6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}]