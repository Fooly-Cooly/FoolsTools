@ECHO OFF
REM ==================================================================
REM	Retrieves version number ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar]
REM Notes: For Windows 2000 and later
REM
REM Copyright ^(C^) 2017  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~1"=="" ECHO Error: No Output Variable Given & GOTO :EOF
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF

	FOR /F "tokens=4,5,6 delims=[].XP " %%A IN ('ver') DO SET "RETURN=%%A.%%B"

:END
ENDLOCAL & SET "%~1=%RETURN%"