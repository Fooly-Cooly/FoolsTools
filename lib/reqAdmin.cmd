@ECHO OFF
REM ==================================================================
REM Checks for Administrator permissions and exit's, even parent
REM Syntax:	%~nx0
REM Notes:	For Windows Vista and later
REM
REM Copyright ^(C^) 2023  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF
	NET FILE >NUL 2>&1
	IF "%ERRORLEVEL%" == "0" ( GOTO :EOF )
	ECHO Error: Admin Permission Required
	PAUSE
	CMD /K
ENDLOCAL 