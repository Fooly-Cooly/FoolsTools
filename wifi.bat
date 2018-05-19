<!-- : Begin batch script
@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion
TITLE WiFi Sharing Menu: Fools Edition
COLOR 17
ECHO.

	REM WiFi Sharing Menu for Windows
	REM Requires Administrator permissions
	REM Only tested on Windows 7 & 10(English version)
	REM This tool can create, start and stop a virtual WiFi access point.
	REM The virtual WLAN AP can be used with any mobile device, etc.
	REM Your WIFI adapter must support Ad-Hoc mode(Intel MyWiFi), most support it.
	REM "Microsoft Virtual WiFi Miniport Adapter" will show in Network Connections
	REM ^(Run ncpa.cpl in a run/command prompt)

	REM Check for admin permissions
	NET FILE >NUL 2>&1
	IF NOT %ERRORLEVEL% == 0 (
		ECHO Administrator permission is required^!
		ECHO Please click [Yes] on the UAC dialog.
		TIMEOUT 5
		cscript //nologo "%~f0?.wsf" //job:Admin
		GOTO :EXIT
	)

	REM Check Ad-Hoc support based on language code page, 437 = English, 936 = Chinese.
	ECHO Checking Ad-Hoc mode support...
	FOR /F "tokens=2 delims=:." %%A IN ('CHCP') DO SET CP=%%A
	IF %CP% == 437 NETSH wlan show drive | find "Hosted network supported" | find "Yes"
	IF %CP% == 936 NETSH wlan show drive | find "支持的承载网络" | find "是"
	IF NOT %ERRORLEVEL% == 0 (
		ECHO Error: WiFi adapter doesn't support Ad-Hoc mode^(hostednetwork^)
		PAUSE
		GOTO :EXIT
	)

	REM Check if input is valid, otherwise display help
	IF "%~1" == "" GOTO :MENU
	CALL :%~1 2>NUL
	IF %ERRORLEVEL% == 1 (
		ECHO Syntax: %~nx0 [Option]
		ECHO    [setup, ssid, password, start, stop, view , share, help]
		ECHO.

		ECHO Copyright (C) 2013 Kingron <kingron@163.com>
		ECHO Modified by Fooly Cooly
		ECHO Licensed with GPL v3 https://www.gnu.org/licenses/gpl-3.0.txt
		ECHO.

		PAUSE
		GOTO :EXIT
	)

	:MENU
	REM Show WiFi Sharing Menu
	CLS
	ECHO   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ECHO   ^|      WiFi Sharing Menu     ^|
	ECHO   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ECHO   ^|  1. Virtual WLAN Setup     ^|
	ECHO   ^|  2. Virtual WLAN Name      ^|
	ECHO   ^|  3. Virtual WLAN Password  ^|
	ECHO   ^|  4. Virtual WLAN Start     ^|
	ECHO   ^|  5. Virtual WLAN Stop      ^|
	ECHO   ^|  6. View WLAN Connections  ^|
	ECHO   ^|  7. Share Connection(ICS)  ^|
	ECHO   ^|  0. Exit                   ^|
	ECHO   ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
	ECHO.

	REM If calling a label fails ERRORLEVEL is set to 1 and the below message appears
	IF %ERRORLEVEL% == 1 ECHO Error: Invalid command, please try again.

	REM Clear the value from last selection
	CALL SET SLC=

	REM Prompt user for input
	SET /p SLC=Select a number and press ^<ENTER^>:

	REM Call user chosen label, pause and reshow menu
	CALL :%SLC% 2>NUL
	IF "%SLC%" == "0" GOTO :EXIT
	PAUSE
	GOTO :MENU

	:1
	:SETUP
		ECHO.
		REM Set access point settings
		NETSH wlan set hostednetwork mode=allow >NUL
		IF !ERRORLEVEL! == 0 ( ECHO WLAN hostednetwork enabled ) ELSE ( ECHO Error: WLAN hostednetwork failed to enable )

		CALL :SSID & ECHO.
		CALL :PASSWORD & ECHO.
		CALL :START & ECHO.

		ECHO NOTE:
		ECHO   Only run "Virtual WLAN Setup" once, if successful.
		ECHO   You needn't run it again unless you want to change the name or password!
		ECHO   Please share an internet connection with virtual WiFi adapter.
	GOTO :EOF

	:2
	:SSID
		REM Prompt user for new name and set it
		SET /p _name=Please input virtual WLAN name: 
		IF %ERRORLEVEL% == 1 CALL SET "_name=WiFi Hotspot" & ECHO Defaulted to !_name!
		NETSH wlan set hostednetwork ssid="%_name%" >NUL
		IF %ERRORLEVEL% == 0 ( ECHO WLAN Name Change Successful ) ELSE ( ECHO Error: WLAN Name Change Failed )
	GOTO :EOF

	:3
	:PASSWORD
		REM Prompt user for new password and set it
		SET /p _password=Please input password^(Length: 8~63^): 
		IF %ERRORLEVEL% == 1 CALL SET "_password=password" & ECHO Defaulted to !_password!
		NETSH wlan set hostednetwork key="%_password%" >NUL
		IF %ERRORLEVEL% == 0 ( ECHO WLAN Password Change Successful ) ELSE ( ECHO Error: WLAN Password Change Failed )
	GOTO :EOF

	:4
	:START
		REM Start WiFi AP and check if it errored
		NETSH wlan start hostednetwork >NUL
		IF %ERRORLEVEL% == 0 ( ECHO WLAN Startup Successful ) ELSE ( ECHO Error: WLAN Startup Failed )
	GOTO :EOF

	:5
	:STOP
		REM Stop WiFi Access Point
		NETSH wlan stop hostednetwork
	GOTO :EOF

	:6
	:VIEW
		REM Show WiFi Access Points
		NETSH wlan show hostednetwork
	GOTO :EOF

	:7
	:SHARE
		REM Runs the internal vbscript to share connections
		cscript //nologo "%~f0?.wsf" //job:Share
	GOTO :EOF

:EXIT
REM Clean up of settings
ENDLOCAL
TITLE Command Prompt
COLOR 7
CLS
EXIT /B

----- Begin wsf script --->
<package>
  <job id="Admin">
    <script language="VBScript">
		File = Left(WScript.ScriptName, Len(WScript.ScriptName) -5)
		Set UAC = CreateObject("Shell.Application")
		UAC.ShellExecute "cmd", "/C " & File, "", "runas", 1
	</script>
  </job>
  <job id="Share">
    <script language="VBScript">
		dim pub, prv, idx

		ICSSC_DEFAULT         = 0
		CONNECTION_PUBLIC     = 0
		CONNECTION_PRIVATE    = 1
		CONNECTION_ALL        = 2

		set NetSharingManager = Wscript.CreateObject("HNetCfg.HNetShare.1")

		wscript.echo "No.   Name" & vbCRLF & "------------------------------------------------------------------"
		idx = 0
		set Connections = NetSharingManager.EnumEveryConnection
		for each Item in Connections
			idx = idx + 1
			set Connection = NetSharingManager.INetSharingConfigurationForINetConnection(Item)
			set Props = NetSharingManager.NetConnectionProps(Item)
			szMsg = CStr(idx) & "     " & Props.Name
			wscript.echo szMsg
		next
		wscript.echo "------------------------------------------------------------------"
		wscript.stdout.write "Select public connection(for internet access) No.: "
		pub = cint(wscript.stdin.readline)
		wscript.stdout.write "Select private connection(for share users) No.: "
		prv = cint(wscript.stdin.readline)
		if pub = prv then
		  wscript.echo "Error: Public can't be same as private!"
		  wscript.quit
		end if

		idx = 0
		set Connections = NetSharingManager.EnumEveryConnection
		for each Item in Connections
			idx = idx + 1
			set Connection = NetSharingManager.INetSharingConfigurationForINetConnection(Item)
			set Props = NetSharingManager.NetConnectionProps(Item)
			if idx = prv then Connection.EnableSharing CONNECTION_PRIVATE
			if idx = pub then Connection.EnableSharing CONNECTION_PUBLIC
		next
	</script>
  </job>
</package>
