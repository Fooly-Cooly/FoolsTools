@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion
	ECHO.
	SET "TAR=%~3"
	REM "FLG=%~2" "PAR1=%~4" "PAR2=%~5"

	REM Checks if input is valid and/or a switch
	IF "%TAR:~0,1%" == "/" (
		ECHO.%~2 | FIND "%TAR:~1%">NUL && ( SET "SUB=%TAR:~1% "%~4" "%~5"" ) || ( GOTO :SYNTAX )
	) ELSE IF NOT "%TAR%" == "" ( SET "SUB=Process "%~dpn3" "%TAR%"" ) ELSE ( GOTO :SYNTAX )

	REM Sets variables for command generation
	SET "EXT=%~1"
	SET "TYP=%EXT:cbr=rar%"
	SET "TYP=%TYP:bz2=bzip2%"
	SET "TYP=%TYP:gz=gzip%"
	CALL "%~dp0getArch" ARC
	CALL "%~dp0getRegVal" RAR "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR archiver" InstallLocation

	REM Sets Compression Profile & Command to be used
	IF "%EXT%" == "7z" (
		IF "%~4" == "Archival" (
			SET "CMD=7za%ARC% a -t7z -mx9 -ms=16g -m0=LZMA2:d256m:fb256"
		) ELSE (
			SET "CMD=7za%ARC% a -t7z -mx9 -ms=16g -m0=LZMA2:d64m:fb64"
		)
	) ELSE IF "%EXT%" == "cb7" (
			SET "CMD=7za%ARC% a -t7z -mx9 -ms=8g -m0=LZMA2:d24m:fb24"
	) ELSE IF "%TYP%" == "rar" (
		SET "CMD="%RAR%rar" a -r -s -ep1 -m5"
	) ELSE (
		SET "CMD=7za%ARC% a -t%TYP% -mx9"
	)
	CALL :%SUB%
	PAUSE
ENDLOCAL & GOTO :EOF	

	:SYNTAX
		ECHO Syntax: %~nx0 [Target] [Profile]
		ECHO.
		ECHO  [Target]
		ECHO.%~2 | FIND "A">NUL && ( ECHO    [/A : Archive All Files ^& Folders In CD] )
		ECHO.%~2 | FIND "F">NUL && ( ECHO    [/F : Archive Individual Folders In CD] )
		ECHO.%~2 | FIND "I">NUL && ( ECHO    [/I : Archive Individual Files In CD] )
		ECHO.%~2 | FIND "S">NUL && ( ECHO    [/S : Compress Executable Installer] )
		ECHO    [Default : Archive Specific File]
		ECHO.
		IF "%~1" == "7z" (
			ECHO  [Profile]
			ECHO    [Archival : LZMA2, Ultra Compression, 256MB Dictionary, 256 Word, 16GB Block]
			ECHO    [Comic    : LZMA2, Ultra Compression,  24MB Dictionary,  24 Word,  8GB Block]
			ECHO    [Default  : LZMA2, Ultra Compression,   ?MB Dictionary,   ? Word,  ?GB Block]
			ECHO.
		)
		ECHO Copyright (C) 2021  Brian Baker https://github.com/Fooly-Cooly
		ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
		ECHO Contact: foolycooly1764@gmail.com
	GOTO :EOF

	:PROCESS
		IF NOT EXIST %2 ( ECHO ERROR: %2 Not Found & GOTO :EOF )
		%CMD% "%~1.%EXT%" "%~2"
	GOTO :EOF

	:A
		CALL :PROCESS "%CD%" "%CD%\*"
	GOTO :EOF

	:F
		FOR /D %%A IN (*) DO CALL :PROCESS "%%~fA" "%%~fA\*"
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
		ENDLOCAL
	GOTO :EOF