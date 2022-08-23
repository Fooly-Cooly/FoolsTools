@ECHO ON
REM ==================================================================
REM Retrieves arg count ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar]
REM Notes:	For Windows XP Pro and later
REM		
REM Copyright ^(C^) 2022  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================

SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~2"=="" ECHO Error: Missing Parameters & GOTO :EOF
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF

	SET "NAME=%~1"
	SET /a "RETURN=0"

	:LOOP
		IF NOT "%~2"=="" (
			SHIFT
			SET /a "RETURN=%RETURN% + 1"
			GOTO :LOOP
		)

ENDLOCAL & SET "%NAME%=%RETURN%"