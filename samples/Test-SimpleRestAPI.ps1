# Copyright 2006 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# This function demonstrates how to use the PowerShell Testing Functions

###
### Before you run this test script, you must run the REST API web service
### defined in SimpleRestAPI.ps1.  You can do this by opening a separate PowerShell
### command window in Administrator mode in the Samples folder and run the following command:
###
###    .\SimpleRestAPI.ps1 "http://localhost:8080/"
###
### The test script assumes that the web service is running on localhost port 8080.
### The accompanying CSV file Test-SimpleRestAPI.csv defines the test cases.

function Test-SimpleWebService([string] $TestCase, [string] $Remark, [string] $Method, [string] $Command, [string] $Parameter, [string] $Value, [string] $ExpectedResponse)
{
    [string]$urlbase="http://localhost:8080/"
    $url = $urlbase + $Command
    if ($Parameter -ne "" -and $Value -ne "") {
        $url = $url + "?" + $Parameter + "=" + $Value
    }

    if ($Method -eq "GET") {
        $Response = Invoke-RestMethod -Uri $url -Method Get -ErrorAction SilentlyContinue
        AssertNotNull $Response -Label "$($TestCase) ResponseNotNull"
        AssertEqual $ExpectedResponse $Response.message -Label "$($TestCase) ExpectedMessage"

    } elseif ($Method -eq "POST") {
        $response = Invoke-RestMethod -Uri $url -Method Post -ErrorAction SilentlyContinue
    } else {
        AssertFail "Unsupported method: $Method" -Label $TestCase
        return
    }
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
. ..\src\DataLib.ps1
. ..\src\TestLib.ps1

# run the function defined above that demonstrates the PowerShell Testing Functions

$FieldNames = ("TestCase","Remark","Method","Command","Parameter","Value","ExpectedResponse")

Start-Test `
    -Path ".\Test-SimpleRestAPI.csv" `
    -Function ${function:Test-SimpleWebService} `
    -Parameters $FieldNames