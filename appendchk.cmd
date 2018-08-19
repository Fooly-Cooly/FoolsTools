@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	IF NOT "%~2" == "" (
		SET "EXE=%~1"
		SET "PAR=%~2"
		SET "LIST=;CRC32;MD5;"
		SET "CHK=!LIST:;%~1;=!"
		SETLOCAL DisableDelayedExpansion
		GOTO :CALL
		
		:CALL
		IF NOT "%CHK%" == "%LIST%" IF "%PAR:~0,1%" == "/" (
			CALL :%PAR:~1%
		) ELSE (
			CALL :PROCESS "%~2"
		)
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
		IF EXIST "%~n1%~x1" (
			ECHO File: "%~n1%~x1"
			ECHO Calculating Checksum...
			FOR /F %%B IN ('%EXE% "%~n1%~x1"') DO (
				SETLOCAL EnableDelayedExpansion
					SET "NAM=%~n1"
					SET "CHK=!NAM:~-1!"
					SET "SUM=%%B"
					IF "!CHK!" == "]" ( SET "SPC=" ) ELSE ( SET "SPC= " )
					GOTO :PROCESS_CONTINUE
			)

			:PROCESS_CONTINUE
			RENAME "%~n1%~x1" "%~n1%SPC%[%SUM%]%~x1"
			ECHO [%SUM%] Appended to Filename
			ENDLOCAL
			ECHO.
		) ELSE ECHO Error: %~n1%~x1 Not Found
	GOTO :EOF

	:A
		ECHO Checksum calculation may take awhile depending on file size...
		ECHO This will append a %EXE% checksum to ALL filenames!
		SET /P "IN=Continue? (Y/N)"
		ECHO.
		IF NOT "%IN%" == "Y" GOTO :END
		FOR %%A IN (*) DO CALL :PROCESS "%%~nxA"
	GOTO :EOF

:END
ENDLOCAL