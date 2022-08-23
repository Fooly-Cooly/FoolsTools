@ECHO OFF
FOR /R %%A IN (*.nes) DO CALL :CHK0 "%%A"
goto END

:CHK0
IF NOT EXIST %1 GOTO END
GOTO R

:UNL
SET STR=%1
::SET STR=%STR:(Tengen)=%
::SET STR=%STR:(Camerica)=%
::SET STR=%STR:(Wisdom Tree)=%
::SET STR=%STR:(Color Dreams)=%
::SET STR=%STR:(Sachen)=%
::SET STR=%STR:(AVE)=%
::SET STR=%STR:(HES)=%
::SET STR=%STR:(AGCI)=%
::SET STR=%STR:(Bunch)=%
::SET STR=%STR:(Active Enterprises)=%
SET STR=%STR:(Unl)=%
SET STR=%STR:[Unl]=%
SET DEST="D:\Unl\"
GOTO CHK1

:HACK
SET STR=%1
SET STR=%STR:Hack=%
SET DEST="D:\Hack\"
GOTO CHK1

:U
SET STR=%1
SET STR=%STR:(U)=%
SET STR=%STR:[U]=%
SET DEST="D:\U\"
GOTO CHK1

:JU
SET STR=%1
SET STR=%STR:(JU)=%
SET STR=%STR:[JU]=%
SET DEST="D:\U\"
GOTO CHK1

:E
SET STR=%1
SET STR=%STR:(E)=%
SET STR=%STR:[E]=%
SET DEST="D:\E\"
GOTO CHK1

:J
SET STR=%1
SET STR=%STR:(J)=%
SET STR=%STR:[J]=%
SET DEST="D:\J\"
GOTO CHK1

:CH
SET STR=%1
SET STR=%STR:(Ch)=%
SET STR=%STR:[Ch]=%
SET DEST="D:\Ch\"
GOTO CHK1

:R
SET STR=%1
SET STR=%STR:(R)=%
SET STR=%STR:[R]=%
SET DEST="D:\R\"
GOTO CHK1

:CHK1
IF NOT x%1==x%STR% CALL :MOVE "%~dp1"
GOTO END

:MOVE
ECHO Moving %1
wscript.exe "%~dp0cmd\movefile.vbs" %1 %DEST%

:END