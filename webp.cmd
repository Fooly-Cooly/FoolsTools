@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF "%~1" == "" ( GOTO :SYNTAX )
	SET "PAR1=%~1"
	SET "PAR2=%~2"
	CALL "%~dp0lib\getArch" ARC

	IF "%PAR1:~0,1%" == "/" (
		ECHO.AR | FIND "%PAR1:~1%">NUL && ( CALL :%PAR1:~1% ) || ( GOTO :SYNTAX )
	) ELSE (
		CALL :PROCESS "%PAR1%"
	)
	PAUSE 
	IF EXIST Webp_Errors.log (
		SET /p DEL="Do you wish to delete log file? (Y/N): "
		IF "%DEL%" == "Y" DEL Webp_Errors.log
	)
ENDLOCAL & GOTO :EOF

	:SYNTAX
		ECHO.
		ECHO Syntax: %~nx0 [[Options] Filename]
		ECHO    [Default : Convert File]
		ECHO    [/A : Convert All Files of CD]
		ECHO    [/R : Convert All Files in CD/Sub]
		ECHO    [-r : Recycle Original Files]
		ECHO Supported Extensions: PNG ^& BMP
		ECHO.
		ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
		ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
		ECHO Contact: foolycooly1764@gmail.com
	GOTO :EOF

	:LOG
		ECHO %~1 >> Webp_Errors.log
		ECHO %~2 >> Webp_Errors.log
		ECHO. >> Webp_Errors.log
		ECHO %~2
	GOTO :EOF

	:PROCESS
		ECHO --------------------------------------------------
		ECHO File: %~f1

		IF NOT EXIST "%~1" ( CALL :LOG "%~f1" "ERROR: 404 File Not Found, Skipping..." & GOTO :PROCESS_END )
		IF EXIST "%~dpn1.webp" ( CALL :LOG "%~f1" "ERROR: 422 File Already Exists, Skipping..." & GOTO :PROCESS_END )

		IF "%~x1" == ".png" ( SET "META=-metadata all" ) ELSE ( SET "META=" )
		RENAME "%~f1" "tmp%~x1"
		START "cwebp" /W /B "%~dp0bin\webp%ARC%\cwebp.exe" "%~dp1tmp%~x1" -lossless -m 4 %META% -mt -progress -q 100 -o "%~dp1tmp.webp"
		RENAME "%~dp1tmp%~x1" "%~nx1" 
		RENAME "%~dp1tmp.webp" "%~n1.webp"
		CALL "%~dp0lib\getFileSize.cmd" "BYTES" "%~n1.webp"

		IF "%BYTES%" EQU "0" (
			nircmd moverecyclebin "%~n1.webp"
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
		FOR %%A IN ("*.png", "*.bmp") DO CALL :PROCESS "%%A"
	GOTO :EOF

	:R
		FOR /R %%A IN ("*.png", "*.bmp") DO CALL :PROCESS "%%A"
	GOTO :EOF