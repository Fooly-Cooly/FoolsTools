@ECHO OFF
SETLOCAL EnableExtensions DisableDelayedExpansion
	IF NOT "%~1" == "" (
		ECHO.
		SET "FLG=I"
		SET "TAR=%~1"
		GOTO :NEXT

		:NEXT
		SETLOCAL EnableDelayedExpansion
			IF NOT "%TAR:~0,2%" == "/" IF NOT "!FLG:%TAR:~1%=!" == "!FLG!" (
				CALL :%TAR:~1%
			) ELSE CALL :PROCESS "!TAR!" "!TAR!"
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
			ffmpeg -i "%~1" -c:v libvpx-vp9 -crf 4 -b:v 0 -auto-alt-ref 0 -metadata:s:v:0 alpha_mode="1" -pix_fmt yuv420p "%~dpn1.webm"
		) ELSE ECHO Error: "%~2" Not Found
	GOTO :EOF

	:I
		FOR %%A IN (*) DO CALL :PROCESS "%%A" "%%A"
	GOTO :EOF

:END
ENDLOCAL