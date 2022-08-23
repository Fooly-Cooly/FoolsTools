REM Command handling call errors in parsing due to file extension. Need to avoid it being parsed b4 execution without delayed expansion.

@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion
	ECHO.
	IF "%~3" == "" ( GOTO :SYNTAX )
	SET "EXT=%~1"
	SET "FLG=%~2"
	SET "TAR=%~3"
	SET "PRO=%~4"
	SET "TYP=%EXT:cb7=7z%"
	SET "TYP=%TYP:cbr=rar%"
	SET "TYP=%TYP:bz2=bzip2%"
	SET "TYP=%TYP:gz=gzip%"
	CALL "%~dp0getArch" ARC
	CALL "%~dp0getRegVal" RAR "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR archiver" InstallLocation

	IF "%TAR:~0,1%" == "/" (
		ECHO.%FLG% | FIND "%TAR:~1%">NUL && ( CALL :%TAR:~1% "%~4" "%~5" ) || ( GOTO :SYNTAX )
	) ELSE (
		CALL :PROCESS "%~dpn3" "%TAR%"
	)
	PAUSE &	GOTO :END

	:SYNTAX
		ECHO Syntax: %~nx0 [File/Folder/Switch] [Profile]
		ECHO.
		ECHO [Switch]
		ECHO    [/A : Archive All Files ^& Folders In CD]
		ECHO    [/F : Archive Individual Folders In CD]
		ECHO    [/I : Archive Individual Files In CD]
		ECHO    [/S : Compress Executable Installer]
		ECHO    [Default : Archive Single Specific File]
		ECHO.
		ECHO [Profile]
		ECHO    [Archival : LZMA2, Ultra Compression, 256MB Dictionary, 256 Word, 16GB Block]
		ECHO    [Comic    : LZMA2, Ultra Compression,  24MB Dictionary,  24 Word,  8GB Block]
		ECHO.
		ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
		ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
		ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:PROCESS
		IF NOT EXIST %2 ( ECHO ERROR: %2 Not Found & GOTO :EOF )
		IF "%TYP%" == "rar" (
			"%RAR%rar" a -r -s -ep1 -m5 "%~1.%EXT%" %2
		) ELSE (
			IF "%PRO%" == "Archival" ( 7za%ARC% a -mx9 -ms=16g -m0=LZMA2:d256m:fb256 -t%TYP% "%~1.%EXT%" %2 )
			IF "%PRO%" == "Comic" ( 7za%ARC% a -mx9 -t%TYP% "%~1.%EXT%" %2 )
			IF "%PRO%" == "" ( 7za%ARC% a -mx9 -t%TYP% "%~1.%EXT%" %2 )
		)
	GOTO :EOF

	:A
		FOR %%A IN (.) DO CALL :PROCESS "%%~dpnA" "%%~dpnA\*"
	GOTO :EOF

	:F
		FOR /D %%A IN (*) DO CALL :PROCESS "%%~dpnA" "%%~dpnA\*"
	GOTO :EOF

	:I
		FOR %%A IN (*) DO CALL :PROCESS "%%~dpnA" "%%~fA"
	GOTO :EOF

	:S
		IF NOT "%~x2" == ".exe" ECHO Error: Incorrect Title or File Given & GOTO :END
		CALL :PROCESS "temp" "%~2"
		ECHO Creating Installer...
		SETLOCAL EnableDelayedExpansion
			ECHO ;^^!@Install@^^!UTF-8^^!> config.txt
			ECHO Title="%~1 Install">> config.txt
			ECHO BeginPrompt="Do you want to install %~1?">> config.txt
			ECHO RunProgram="%~nx2">> config.txt
			ECHO ;^^!@InstallEnd@^^!>> config.txt
			COPY /B "%~dp0..\bin\7zSD.sfx" + "config.txt" + "temp.7z" "%~n2.new.exe"
			DEL /Q "temp.7z"
			DEL /Q "config.txt"
	GOTO :EOF

:END
ENDLOCAL