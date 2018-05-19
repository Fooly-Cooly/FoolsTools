<!-- : Begin batch script
@ECHO OFF
REM ==================================================================
REM	Retrieves shortcut command value ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar] [ShortcutPath]
REM Notes: For Windows 2000 and later
REM
REM Copyright ^(C^) 2017  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	SET "vbscript=cscript //nologo ""%~f0?.wsf"" //job:Read"
	FOR /f "delims=" %%A in ( ' %vbscript% "%~2" ' ) DO SET "RETURN=%%A"
ENDLOCAL & SET "%~1=%RETURN%" & GOTO :EOF

----- Begin wsf script --->
<package>
  <job id="Read">
    <script language="VBScript">
		SET WshShell = WScript.CreateObject("WScript.Shell")
		SET Lnk = WshShell.CreateShortcut(WScript.Arguments.Unnamed(0))
		wscript.Echo Lnk.TargetPath
	</script>
  </job>
</package>