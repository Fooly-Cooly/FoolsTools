net stop wlansvc
Remove-Item "HKLM:\system\currentcontrolset\services\wlansvc\parameters\hostednetworksettings"
net start wlansvc