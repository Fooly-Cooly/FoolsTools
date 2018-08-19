@ECHO OFF
SET "PAR=%~1x"
SET "EXT="*.webm",  "*.mkv""
IF "%PAR:~0,1%" == "/" CALL :%PAR:~1,-1%
IF NOT "%PAR%" == "x" CALL :PROCESS
GOTO :PAUSE
ECHO Syntax: %0 [[/Option] Filename]
ECHO	[Default : Convert File]
ECHO    [/I : Convert All Files of CD]
ECHO    [/R : Convert All Files of CD/Sub]
GOTO :EOF

:PROCESS
ffmpeg -i %1 -vn -acodec copy "%~dpn1.ogg"
GOTO :EOF

:I
FOR %%X IN (%EXT%) DO CALL :PROCESS "%%X"
GOTO :EOF

:R
FOR /R %%X IN (%EXT%) DO CALL :PROCESS "%%X"
GOTO :EOF

:PAUSE
PAUSE