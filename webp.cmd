@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	IF NOT "%~1" == "" (
		SET "PAR=%~1"
		CALL "%~dp0lib\getArch" ARC
		IF "!PAR:~0,1!" == "/" GOTO :!PAR:~1!
		CALL :PROCESS "%~1"
		GOTO :PAUSE
	)
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
		IF EXIST "%~1" (
			ECHO.
			IF %ARC% == x86 %~dp0bin\webp\cwebp.exe "%~1" -q 100 -lossless -o "%~dpn1.webp"
			IF %ARC% == x64 %~dp0bin\webp64\cwebp.exe "%~1" -q 100 -lossless -o "%~dpn1.webp"
			IF "%~2" == "-r" nircmd moverecyclebin "%~dpnx1"
		) ELSE ECHO Error: 404 File Not Found
	GOTO :EOF

	:A
		FOR %%A IN ("*.png", "*.bmp") DO CALL :PROCESS "%%A" "%~2"
	GOTO :PAUSE

	:R
		FOR /R %%A IN ("*.png", "*.bmp") DO CALL :PROCESS "%%A" "%~2"
	GOTO :PAUSE

	:PAUSE
		PAUSE

:END
ENDLOCAL