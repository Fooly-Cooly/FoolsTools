IF {%1}=={} SET _empty=Syntax: isempty.cmd "Folder to check"
IF NOT EXSIST %1 SET _empty=No_Such_Folder
DIR %1 /b | find /v "RandomString64" >nul && (SET _empty=NotEmpty) || (SET _empty=Empty)