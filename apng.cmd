@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	IF NOT "%~1" == "" (
		SET "PAR=%~1"
		IF "!PAR:~0,1!" == "/" GOTO :!PAR:~1!
		GOTO :FILE
	)
	ECHO Syntax: %0 [[/Option] Filename]
	ECHO    [Default : Convert Single File]
	ECHO    [/I : Convert All CD Gif Files]
	ECHO    [/O : Optimize All CD APNG Files]
	ECHO.
	ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
	ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
	ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:FILE
		gif2apng -z2 "%~1" "%~dpn1.apng"
	GOTO :PAUSE

	:I
		FOR %%A IN (*.gif) DO gif2apng -z2 "%%A" ".APNG\%%~nA.apng"
	GOTO :PAUSE

	:O
		FOR %%A IN (*.apng) DO apngopt -z2 "%%A" ".APNGOpt\%%~nA.apng"
	GOTO :PAUSE

	:PAUSE
		PAUSE

:END
ENDLOCAL