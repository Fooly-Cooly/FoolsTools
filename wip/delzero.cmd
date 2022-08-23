IF EXIST %1 IF %~z1==0 (
	DEL %1
	ECHO File Deleted: %1
	ECHO File Deleted: %1 >> deleted.log
)