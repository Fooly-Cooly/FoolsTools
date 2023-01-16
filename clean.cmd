@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	SET "PAR=%~1"
	IF NOT "!PAR:~0,1!" == "/" ( GOTO :SYNTAX )
	CALL :!PAR:~1!
	PAUSE
GOTO :EOF

	:SYNTAX
		ECHO.
		ECHO Syntax: %~nx0 [/Switch]
		ECHO    [/C : Clear Empty Files ^& Folders]
		ECHO    [/I : Clear Windows Icon Cache]
		ECHO.
		ECHO Copyright (C) 2023  Brian Baker https://github.com/Fooly-Cooly
		ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
		ECHO Contact: foolycooly1764@gmail.com
	GOTO :EOF

	:LOG
		ECHO %~1 >> %~n0_Errors.log
		ECHO %~2 >> %~n0_Errors.log
		ECHO. >> %~n0_Errors.log
		ECHO %~1
		ECHO %~2
		ECHO.
	GOTO :EOF

	:C
		ECHO Deleting Empty Files...
		FOR /R %%A IN (*) DO CALL :CLOOP "%%A" getFileSize.cmd Files
		ECHO.
		ECHO Deleting Empty Folders...
		FOR /R /D %%B IN (*) DO CALL :CLOOP "%%B" getFileCount.cmd
		GOTO :CEND

		:CLOOP
			IF NOT EXIST "%~1" ( CALL :LOG "%~1" "ERROR: 404 Not Found, Skipping..." & GOTO :EOF )

			CALL "%~dp0lib\%~2" "BYTES" "%~1"
			IF "%BYTES%" NEQ "0" ( GOTO :EOF )

			IF "%~3" == "Files" ( DEL "%~1" ) ELSE ( RMDIR "%~1" )
			IF EXIST "%~1" (CALL :LOG "%~1" "ERROR: Couldn't Be Deleted, Skipping...") ELSE (ECHO Deleted "%~1")
		GOTO :EOF

		:CEND
		IF NOT EXIST %~n0_Errors.log ( GOTO :EOF )
		SET /p DEL="Do you wish to delete log file? (Y/N): "
		IF /I "%DEL%" == "Y" ( DEL %~n0_Errors.log )
	GOTO :EOF

	:IC
		SET iconcache=%localappdata%\IconCache.db
		ECHO The Explorer process must be killed to delete the Icon DB.
		ECHO.
		ECHO Please SAVE ALL OPEN WORK before continuing.
		ECHO.
		PAUSE
		ECHO.
		IF EXIST "%iconcache%" (
			ECHO Attempting to delete Icon DB...
			ECHO.
			ie4uinit.exe -ClearIconCache
			taskkill /IM explorer.exe /F
			DEL "%iconcache%" /A
			ECHO.
			ECHO Icon DB has been successfully deleted. Please "reSTART your PC" now to rebuild your icon cache.
			ECHO.
			START explorer.exe
			PAUSE
			EXIT /B
		)
		ECHO.
		ECHO Icon DB has already been deleted.
		ECHO.
		PAUSE
	GOTO :EOF