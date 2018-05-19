@ECHO OFF
SETLOCAL
	REM	CALL readCFG.cmd RETURN "%~dp0\..\cfg\config.ini" Default default
	ECHO.
	ECHO CD:	%CD%
	ECHO DIR:	%~dp0
	ECHO PARAM:	%*
	ECHO.
	REM	ECHO %RETURN%
	PAUSE
ENDLOCAL