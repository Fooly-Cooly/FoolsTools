CALL "%~dp0isempty.cmd" %1
IF %_empty%==Empty (
	RD %1
	ECHO Folder Deleted: %1
	ECHO Folder Deleted: %1 >> deleted.log
)