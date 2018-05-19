@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	SET "LIST=;CRC32;MD5;"
	IF NOT "!LIST:;%~1;=!" == "!LIST!" IF NOT "%~2" == "" (
		SET "EXE=%~1"
		SET "PAR=%~2"
		IF "!PAR:~0,1!" == "/" ( CALL :!PAR:~1! ) ELSE ( CALL :PROCESS "%~2" )
		PAUSE & GOTO :END
	)

	ECHO Syntax: %~nx0 [CRC32/MD5] [File/Switch]
	ECHO    [/A : Append to All Files In CD]
	ECHO    [Default : Append to Specific File]
	ECHO.
	ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
	ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
	ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:PROCESS
		IF EXIST "%~1" (
			ECHO File: "%~1"
			ECHO Calculating Checksum...
			FOR /F  %%B IN ('%EXE% "%~1"') DO (
				SET "NAM=%~n1"
				SET "EXT=%~x1"
				SET "CRC=%%B"
				SET "CHK=!NAM:~-1!"

				IF "!CHK!" == "]" ( SET "SPC=" ) ELSE ( SET "SPC= " )
				RENAME "!NAM!!EXT!" "!NAM!!SPC![!CRC!]!EXT!"

				ECHO [!CRC!] Appended to Filename
				ECHO.
			)
		) ELSE ECHO Error: %~1 Not Found
	GOTO :EOF

	:A
		ECHO Checksum calculation may take awhile depending on file size...
		ECHO This will append a %EXE% checksum to ALL filenames!
		SET /P "IN=Continue? (Y/N)"
		ECHO.
		IF NOT "%IN%" == "Y" GOTO :END
		FOR /F "delims=" %%A IN ('DIR /A-D /B') DO CALL :PROCESS "%%~nxA"
	GOTO :EOF

:END
ENDLOCAL