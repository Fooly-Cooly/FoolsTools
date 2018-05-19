@ECHO OFF
REM ==================================================================
REM Checks for Administrator permissions and exit's, even parent
REM Syntax:	%~nx0
REM Notes:	For Windows Vista and later
REM
REM Copyright ^(C^) 2017  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :END

	NET FILE >NUL 2>&1
	IF NOT "%ERRORLEVEL%" == "0" (
		ECHO Error: Admin Permission Required
		(GOTO) 2>NUL
		EXIT /B
	)

:END
ENDLOCAL