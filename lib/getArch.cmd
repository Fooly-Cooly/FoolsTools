@ECHO OFF
REM ==================================================================
REM Retrieves CPU architecture ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar]
REM Notes:	For Windows XP Pro and later
REM		
REM Copyright ^(C^) 2017  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~1"=="" ECHO Error: Missing Parameters & GOTO :EOF
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF
	REG Query "HKLM\Hardware\Description\System\CentralProcessor\0" | FIND /i "x86" > NUL && SET "RETURN=" || SET "RETURN=64"
ENDLOCAL & SET "%~1=%RETURN%"