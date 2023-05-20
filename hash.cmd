@ECHO OFF & ECHO.
SETLOCAL EnableExtensions DisableDelayedExpansion
	ECHO.;CRC32;MD5;xxhsum; | FIND /I ";%~1;">NUL && ( CALL ) || ( GOTO :SYNTAX )
	IF "%~2" == "" ( GOTO :SYNTAX )

	SET "EXE=%~1"
	SET "PAR1=%~2"
	SET "PAR2=%~3"
	CALL "%~dp0lib\getArch" ARC

	IF "%PAR1:~0,1%" == "/" (
		ECHO.A | FIND "%PAR1:~1%">NUL && ( CALL :%PAR1:~1% ) || ( GOTO :SYNTAX )
	) ELSE (
		CALL :PROCESS "%PAR1%"
	)
	PAUSE & GOTO :END

	:SYNTAX
	ECHO Syntax: %~nx0 [CRC32/MD5/xxhsum] [File/Switch] [Flag]
	ECHO    [/A : Hash All Files In CD]
	ECHO    [-a : Save Hash to Filename]
	ECHO    [-s : Save Hash to File]
	ECHO    [Default : Append to Specific File]
	ECHO.
	ECHO Copyright (C) 2023  Brian Baker https://github.com/Fooly-Cooly
	ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
	ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:PROCESS
		IF EXIST "%~n1%~x1" (
			ECHO File: "%~n1%~x1"
			ECHO Calculating Checksum...
			FOR /F %%B IN ('%EXE%%ARC% "%~n1%~x1"') DO (
				SET "SUM=%%B"
				GOTO :PROCESS_CONTINUE
			)
			:PROCESS_CONTINUE
			IF "%PAR2%" == "-s" (
				FOR %%I IN ("%CD%") DO ECHO %SUM% %~1>> "%CD%\%%~nI.%EXE%"
			)
			IF "%PAR2%" == "-a" (
				SET "NAM=%~n1"
				SET "CHK=%NAM:~-1%"
				IF "%CHK%" == "]" ( SET "SPC=" ) ELSE ( SET "SPC= " )
				RENAME "%~n1%~x1" "%~n1%SPC%[%SUM%]%~x1"
			)
			ECHO Hash: %SUM%
			ECHO.
		) ELSE ECHO Error: %~n1%~x1 Not Found
	GOTO :EOF

	:A
		ECHO This will generate a %EXE% sfv file containing current directory files checksums.
		ECHO Checksum calculation may take awhile depending on file size...
		SET /P "IN=Continue? (Y/N)"
		ECHO.
		IF NOT "%IN%" == "Y" GOTO :END
		FOR %%A IN (*) DO CALL :PROCESS "%%~nxA"
	GOTO :EOF

:END
ENDLOCAL