PUSHD "%~dp0"
DIR /b %SystemRoot%\servicing\Packages\*Hyper-V*.mum >hyper-v.txt
FOR /f %%i in ('findstr /i . hyper-v.txt 2^>nul') do dism /online /norestart /add-package:"%SystemRoot%\servicing\Packages\%%i"
DEL hyper-v.txt
Dism /online /enable-feature /featurename:Microsoft-Hyper-V -All /LimitAccess /ALL
PAUSE