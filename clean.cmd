@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	IF NOT "%~1" == "" (
		SET "PAR=%~1"
		IF "!PAR:~0,1!" == "/" ( CALL :!PAR:~1! ) ELSE ( CALL :DEFAULT )
		PAUSE & GOTO :END
	)

	ECHO Syntax: %~nx0 [/Switch]
	ECHO    [/C : Clear Empty Files ^& Folders]
	ECHO    [/I : Clear Windows Icon Cache]
	ECHO    [Default : Append to Specific File]
	ECHO.
	ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
	ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
	ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:C
		ECHO Deleting Empty Files...
		FOR /R %%A IN (*) DO IF "%%~zA" == "0" ECHO Removing "%%A"... & DEL "%%A"
		ECHO.

		%~dp0lib\nircmdc.exe wait 3000
		ECHO Deleting Empty Folders...
		FOR /R /D %%B IN (*) DO ECHO Removing "%%B"... & RMDIR "%%B"
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

:END
ENDLOCAL