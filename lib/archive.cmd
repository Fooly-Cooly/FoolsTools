@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
	IF NOT "%~3" == "" (
			ECHO.
			SET "EXT=%~1"
			SET "FLG=%~2"
			SET "TAR=%~3"
			CALL "%~dp0getArch" ARC
			CALL "%~dp0getRegVal" RAR "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall\WinRAR archiver" InstallLocation	
			SET "TYP=!EXT:cb7=7z!"
			SET "TYP=!TYP:cbr=rar!"
			SET "TYP=!TYP:gz=gzip!"
			SET "TYP=!TYP:bz2=bzip2!"
			SET "CHK=!FLG:%TAR:~1%=!"
			SETLOCAL DisableDelayedExpansion
		GOTO :NEXT
		
		:NEXT
		IF NOT "%CHK%" == "%FLG%" IF NOT "%TAR:~0,2%" == "/" (
			CALL :%TAR:~1%
		) ELSE (
			CALL :PROCESS "%TAR%" "%TAR%"
		)
		PAUSE & GOTO :END
	)

	ECHO Syntax: %~nx0 [File/Folder/Switch]
	ECHO    [/A : Archive All Files ^& Folders In CD]
	ECHO    [/F : Archive Individual Folders In CD]
	ECHO    [/I : Archive Individual Files In CD]
	ECHO    [/S : Compress Executable Installer]
	ECHO    [Default : Archive Single Specific File]
	ECHO.
	ECHO Copyright (C) 2017  Brian Baker https://github.com/Fooly-Cooly
	ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
	ECHO Contact: foolycooly1764@gmail.com
	GOTO :END

	:PROCESS
		IF EXIST "%~2" (
			IF "%TYP%" == "rar" (
				"%RAR%rar" a -r -s -ep1 -m5 "%~1.%EXT%" %2
			) ELSE (
				IF %ARC% == x86 7za a -mx9 -t%TYP% "%~1.%EXT%" %2
				IF %ARC% == x64 7za64 a -mx9 -t%TYP% "%~1.%EXT%" %2
			)
		) ELSE ECHO Error: "%~2" Not Found
	GOTO :EOF

	:A
		FOR %%A IN (.) DO CALL :PROCESS "%%~nxA" "*"
	GOTO :EOF

	:F
		FOR /D %%A IN (*) DO CALL :PROCESS "%%A" ".\%%A\*"
	GOTO :EOF

	:I
		MKDIR ".\+Compressed"
		FOR %%A IN (*) DO CALL :PROCESS ".\+Compressed\%%~nA" "%%A"
	GOTO :EOF

	:S
	IF NOT "%~x5" == ".exe" ECHO Error: Incorrect Title or File Given & GOTO :END
	CALL :PROCESS "temp" "%~5"
	ECHO Creating Installer...
	SETLOCAL EnableDelayedExpansion
		ECHO ;^^!@Install@^^!UTF-8^^!> config.txt
		ECHO Title="%~4 Install">> config.txt
		ECHO BeginPrompt="Do you want to install %~4?">> config.txt
		ECHO RunProgram="%~nx5">> config.txt
		ECHO ;^^!@InstallEnd@^^!>> config.txt
		COPY /B "%~dp0..\..\bin\7zS.sfx" + "config.txt" + "temp.7z" "%~n5.new.exe"
		DEL /Q "temp.7z"
		DEL /Q "config.txt"
	GOTO :EOF

:END
ENDLOCAL