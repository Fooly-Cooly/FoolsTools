@ECHO OFF
REM ==================================================================
REM Retrieves folder file count ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar] [Folder]
REM Notes:	For Windows XP Pro and later
REM		
REM Copyright ^(C^) 2023  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~1"=="" ECHO Error: Missing Parameters & GOTO :EOF
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF
	FOR /f %%A IN ('2^>NUL DIR "%~2" /a-d-s-h /b ^| FIND /v /c ""') DO SET "RETURN=%%A"
ENDLOCAL & SET "%~1=%RETURN%"