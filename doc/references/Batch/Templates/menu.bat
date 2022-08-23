@ECHO OFF
REM.-- Prepare the Command Processor
SETLOCAL ENABLEEXTENSIONS ENABLEDELAYEDEXPANSION

:menuLOOP
ECHO.
ECHO.= Menu =================================================
ECHO.
FOR /f "tokens=1,2,* delims=_ " %%A in ('"findstr /b /c:":menu_" "%~f0""') DO ECHO.  %%B  %%C
SET choice=
ECHO. & SET /p choice=Make a choice or hit ENTER to quit: ||GOTO:EOF
ECHO. & CALL :menu_%choice%
GOTO:menuLOOP

::-----------------------------------------------------------
:: menu functions follow below here
::-----------------------------------------------------------

:menu_1   Option 1
::Command 1
GOTO:menu_Q

:menu_2   Option 2
::Command 2
GOTO:menu_Q

:menu_3   Option 3
::Command 3
GOTO:menu_Q

:menu_

:menu_Q   Quit
::Command Q
EXIT