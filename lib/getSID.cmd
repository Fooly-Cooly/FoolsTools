@ECHO OFF
REM ==================================================================
REM Retrieves SID of specified user ^& sets OutputVar
REM Syntax:	%~nx0 [OutputVar] [UserName]
REM Notes:	For Windows XP Pro and later
REM		
REM Copyright ^(C^) 2017  Brian Baker https://github.com/Fooly-Cooly
REM Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
REM Contact: foolycooly1764@gmail.com
REM ==================================================================
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~2"=="" ECHO Error: Missing Parameters & GOTO :EOF
	IF NOT "%OS%"=="Windows_NT" ECHO Error: Unsupported OS & GOTO :EOF

	FOR /F "delims= " %%A IN ('"wmic path win32_useraccount where name="%~2" get sid"') DO (
		IF NOT "%%A"=="SID" (
			SET "RETURN=%%A"
			GOTO :END
	   )   
	)

:END
ENDLOCAL & SET "%~1=%RETURN%"