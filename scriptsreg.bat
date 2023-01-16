@ECHO OFF
CALL "%~dp0lib\reqadmin.cmd"
SETLOCAL ENABLEDELAYEDEXPANSION
TITLE Powershell Scripts
COLOR 17

:BUILDMENU
REM | Get script names and put in variables
ECHO.
ECHO Getting Script list...
ECHO.
SET /A MAXITEM=0
PUSHD "%~dp0"
FOR %%M IN ("./reg/*.reg") DO (
	SET /A MAXITEM=!MAXITEM!+1
	SET MENUITEM!MAXITEM!=%%M
)
POPD

:SHOWMENU
REM | Build menu and count items
CLS
SET CHOICE=0
ECHO.
ECHO.= Registry Scripts =========================================
ECHO.
FOR /L %%I IN (1,1,!MAXITEM!) DO ECHO    %%I. !MENUITEM%%I!
ECHO.
SET /P CHOICE="Select script to run or Q to quit: "
IF /I %CHOICE%==q GOTO EXIT
IF %CHOICE% GTR !MAXITEM! GOTO SHOWMENU
IF %CHOICE%==0 GOTO SHOWMENU
SET PKGNAME=!MENUITEM%CHOICE%!

REM | Verify choice & execute
ECHO.
SET /P YESNO="Run %PKGNAME%? (Y/N): "
IF NOT %YESNO%==y IF NOT %YESNO%==Y GOTO SHOWMENU
CLS
REGEDIT.EXE /S "%PKGNAME%"
PAUSE
GOTO BUILDMENU

:EXIT
CLS
COLOR
ENDLOCAL