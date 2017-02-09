$installedApps = gci "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall" | foreach-object{get-itemproperty $_.PSPath} | select-object DisplayName | %{$appsList += "$_ "}

$desiredAppsList = 
    "EndNote", 
    "AutoIt",
    "Adobe Flash Player ActiveX",
    "Adobe Flash Player Plugin",
    "AVG 7.5",
    "CyberScrub® Privacy Suite",
    "JGsoft EditPad Pro 6 v.6.3.2",
    "Microsoft Visual Studio 2005 Premier Partner Edition - ENU Service Pack 1",
    "Microsoft Visual Studio 2005 Professional Edition - ENU Service Pack 1",
    "Microsoft Visual Studio 2005 Team Suite - ENU Service Pack 1",
    "Microsoft Visual Studio 2005 Team Explorer - ENU Service Pack 1",
    "Microsoft SQL Server 2005",
    "Microsoft Visual J# 2.0 Redistributable Package",
    "Microsoft Visual Studio 2005 Professional Edition - ENU",
    "Microsoft Visual Studio 2005 Team Explorer - ENU",
    "Microsoft Visual Studio 2005 Team Suite - ENU",
    "Microsoft Visual Studio 2005 Tools for Office Runtime",
    "Mozilla Firefox"

$desiredAppsList | foreach-object {
	AssertMatch $appsList $_ -Label $_
}

RaiseAssertions