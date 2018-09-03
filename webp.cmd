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
	PAUSE & GOTO :END

	:SYNTAX
	ECHO.
	ECHO Syntax: %~nx0 [[Options] Filename]
	ECHO    [Default : Convert File]
	ECHO    [/A : Convert All Files of CD]
	ECHO    [/R : Convert All Files in CD/Sub]
	ECHO    [-r : Delete Original Files]
	ECHO.
	ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
	ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
	ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:PROCESS
		IF NOT EXIST "%~1" ECHO ERROR: 404 File Not Found & GOTO :EOF
		IF EXIST "%~dpn1.webp" ECHO ERROR: 422 File Already Exists, Skipping... & GOTO :EOF
		ECHO.

		RENAME "%~f1" "tmp%~x1"
		START "cwebp" /W /B %~dp0bin\webp%ARC%\cwebp.exe "%~dp1tmp%~x1" -q 100 -lossless -o "%~dp1tmp.webp"
		RENAME "%~dp1tmp%~x1" "%~nx1" 
		RENAME "%~dp1tmp.webp" "%~n1.webp"

		IF "%PAR2%" == "-r" nircmd moverecyclebin "%~f1"
	GOTO :EOF

	:A
		FOR %%A IN ("*.png", "*.bmp") DO CALL :PROCESS "%%A"
	GOTO :EOF

	:R
		FOR /R %%A IN ("*.png", "*.bmp") DO CALL :PROCESS "%%A"
	GOTO :EOF

:END
ENDLOCAL