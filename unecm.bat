@ECHO OFF
ECHO If you need to apply any patch, do it AFTER unpacking
ECHO (apply in the resulting file, not the .ecm file).
ECHO.
ECHO Press CTRL+C to cancel.
PAUSE
FOR %%X IN ("*.ecm") DO UNECM "%%~X" "%%~nX"
ECHO If the process was successful, you can delete the .ecm file.
PAUSE