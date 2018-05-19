@ECHO OFF
REM ==================================================================
REM	Retrieves registry value ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar] [KeyName] [ValueName]
REM Notes: For Windows 2000 and later
REM
REM Copyright ^(C^) 2017  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~3"=="" ECHO Error: Missing Parameters & GOTO :EOF
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF
	IF "%~3"=="" (SET "VALUE=/ve") ELSE (SET "VALUE=/v %3")

	FOR /F "tokens=2,* eol=@" %%A IN ('REG QUERY %2 %VALUE%') DO SET "RETURN=%%B"

:END
ENDLOCAL & SET "%~1=%RETURN%"