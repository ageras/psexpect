# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0


# Exercises the target of the test - the get-weather web service
# and then verifies the results against the expected values that are also on the 
# worksheet (in this simple case, the $title parameter)
function TestGetWeather()
{
    param(  [string]$TestCase, `
            [string]$Remark, `
            [string]$Zip, `
            [string]$Units, `
            [string]$Title)

    if ($Units -eq "$null") { $Units = $null }
    if ($Zip -eq "$null") { $Zip = $null }
    
    [string]$urlbase="http://xml.weather.yahoo.com/forecastrss"
    [string]$url=$urlbase + "?p="+$Zip+"&u="+$Units
    
    write-host Connecting to $url
    
    # create .NET Webclient object and call the web service
    $webclient = new-object "System.Net.WebClient"
    $targetBlock = {[xml]$weather=$webclient.DownloadString($url)}

    # measure the results and verify
    $targetBlock | AssertFaster -MaximumTime 300 -Label ($TestCase + "-P")

    # also check for correctness
    [xml]$weather=$webclient.DownloadString($url)
    $actualTitle = $weather.rss.channel.item.Title.PadRight(30," ").Substring(0,29).Trim()
    AssertEqual $Title $actualTitle -Label $TestCase
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the test by calling DataLib\start-test function
$FieldNames = ("TestCase","Remark","Zip","Units","Title")
start-test ((get-location).ToString() + "\TestGetWeather.xls") "Sheet1" `
    "TestGetWeather" $FieldNames