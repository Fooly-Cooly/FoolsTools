@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~1" == "" ( GOTO :SYNTAX )
	SET "PAR1=%~1"
	SET "PAR2=%~2"

	IF "%PAR1:~0,1%" == "/" (
		ECHO.AR | FIND "%PAR1:~1%">NUL && ( CALL :%PAR1:~1% ) || ( GOTO :SYNTAX )
	) ELSE (
		CALL :PROCESS "%PAR1%"
	)
	PAUSE

	IF NOT EXIST %~n0_Errors.log ( GOTO :EOF )
	SET /p DEL="Do you wish to delete log file? (Y/N): "
	IF /I "%DEL%" == "Y" ( DEL %~n0_Errors.log )
GOTO :EOF

	:SYNTAX
		ECHO.
		ECHO Syntax: %~nx0 [[Options] Filename]
		ECHO    [Default : Convert File]
		ECHO    [/A : Convert All Files of CD]
		ECHO    [/R : Convert All Files in CD/Sub]
		ECHO    [-r : Recycle Original Files]
		ECHO.
		ECHO Copyright (C) 2023  Brian Baker https://github.com/Fooly-Cooly
		ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
		ECHO Contact: foolycooly1764@gmail.com
	GOTO :EOF

	:LOG
		ECHO %~1 >> %~n0_Errors.log
		ECHO %~2 >> %~n0_Errors.log
		ECHO. >> %~n0_Errors.log
		ECHO %~2
	GOTO :EOF

	:PROCESS
		ECHO --------------------------------------------------
		ECHO File: %~f1

		IF NOT EXIST "%~1" ( CALL :LOG "%~f1" "ERROR: 404 File Not Found, Skipping..." & GOTO :PROCESS_END )
		IF EXIST "%~dpn1.apng" ( CALL :LOG "%~f1" "ERROR: 422 File Already Exists, Skipping..." & GOTO :PROCESS_END )

		RENAME "%~f1" "tmp%~x1"
		START "gif2apng" /W /B "gif2apng.exe" -z1 "%~dp1tmp%~x1" "%~dp1tmp.apng"
		RENAME "%~dp1tmp%~x1" "%~nx1"
		RENAME "%~dp1tmp.apng" "%~n1.apng"

		CALL "%~dp0lib\getFileSize.cmd" "BYTES" "%~n1.apng"
		IF "%BYTES%" EQU "0" (
			nircmd moverecyclebin "%~n1.apng"
			CALL :LOG "%~f1" "ERROR: Conversion Failed"
			GOTO :PROCESS_END
		)
		IF "%PAR2%" == "-r" ( nircmd moverecyclebin "%~f1" )
		ECHO Conversion Successful!

		:PROCESS_END
		ECHO --------------------------------------------------
		ECHO.
	GOTO :EOF

	:A
		FOR %%A IN ("*.gif") DO CALL :PROCESS "%%A"
	GOTO :EOF

	:R
		FOR /R %%A IN ("*.gif") DO CALL :PROCESS "%%A"
	GOTO :EOF