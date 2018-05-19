@ECHO OFF

REM 
REM Tweakradje 2014, V2
REM 
REM Find all Packages and remove the ones indicated
REM
REM Good info: http://technet.microsoft.com/en-us/library/hh825265.aspx
REM
REM  DISM /online /Get-Packages /Format=Table
REM  DISM /online /Get-Drivers /Format=Table
REM  DISM /online /Get-Features /Format=Table to enable/disable/remove
REM  

Title Remove Windows Packages from local store
Color 17
Setlocal ENABLEDELAYEDEXPANSION

:BUILDMENU
Echo.
Echo Getting package list...
Echo.
SET /A MAXITEM=0
REM ### Get the output lines from the command and store them in Environment variables
REM ### We want the output of Findstr.exe, Not DISM.exe, hence the ^ symbol
For /f "skip=3 delims=" %%M in ('"DISM /online /Get-Packages /Format=Table"^|FindStr :') do (
	Set /A MAXITEM=!MAXITEM!+1
	Set MENUITEM!MAXITEM!=%%M
)

:SHOWMENU
Cls
Echo.
Echo.
Set CHOICE=0
REM ### Build the menu on screen and count the items
For /L %%I in (1,1,!MAXITEM!) do Echo    %%I. !MENUITEM%%I!
Echo.
SET /P CHOICE="Select (superseeded?) Package to remove or Q to quit: "
Echo.
IF %CHOICE%==q Goto BYE
IF %CHOICE%==Q Goto BYE
IF %CHOICE% Gtr !MAXITEM! Goto SHOWMENU
IF %CHOICE%==0 Goto SHOWMENU

REM ### Get the text for selected item from the proper Environment variable
Echo.
REM ### We want only left part of the first | with package name
For /f "delims=| " %%S in ("!MENUITEM%CHOICE%!") Do Set PKGNAME=%%S
Echo Removing "%PKGNAME%"
Echo.
Set /P YESNO="Are you sure (Y/N): "
If Not %YESNO%==y If Not %YESNO%==Y Goto SHOWMENU
DISM /online /Remove-Package /PackageName:"%PKGNAME%"
pause
Goto BUILDMENU


:BYE
Color
EndLocal