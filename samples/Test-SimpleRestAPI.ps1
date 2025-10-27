# Copyright 2006 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Demonstrates the Collect function
# function TestGetWeather
# {

#     # specify the workbook full path
#     $theFolder = get-location
#     $WorkbookFullPath = $theFolder.ToString() + "\TestGetWeather.xls"

#     # identify the worksheet that the test data is on
#     $WorksheetName = "Sheet1"

#     # identify a range - it's a good idea to use Excel's named ranges
#     # so that you don't have to change your script if you add test cases.
#     # You just have to re-define the named range.
#     $RangeName = "TestCases"

#     # specify the names of each column - doesn't have to agree with what is
#     # on the spreadsheet
#     $FieldNames = "TestCase","Remark","Zip","Units","Title"

#     # retrieve a list of the contents of the range
#     $fileExists = test-path $WorkbookFullPath
#     if (!$fileExists) { return $null }

#     # start Excel
#     $excel = New-Object -comobject Excel.Application

#     # get the data
#     $workbook = open-workbook $excel $WorkbookFullPath
#     $worksheet = get-worksheet $workbook $WorksheetName
#     $range = get-range $worksheet $RangeName
#     $rangeAsList = collect-range $range $FieldNames

#     if ($rangeAsList -ne $null) {
#         write-host "There are " $rangeAsList.Count " test cases."
    
#         # make sure it's not null
#         AssertNotNull $rangeAsList "GWXL-1"
    
#         # for each row in the test cases range,
#         foreach ($item in $rangeAsList) {
    
#             # exercise the target of the test
#             $proc = TestGetWeatherFixture $item.Zip $item.Units
    
#             # check the actual results against the expected results on the worksheet
#             # and use the label from the worksheet's first column 
#             $actual = $proc.PadRight(30," ").Substring(0,29).Trim()
#             $expected = $item.Title
#             AssertEqual $expected $actual $item.TestCase
    
#         }
#         RaiseAssertions

#     } else {
#         write-host "Couldn't find the workbook."
#     }

#     # this is how you ensure that no references are left on your COM object so
#     # that it does actually quit
#     $excel.Quit()
#     $a = release-range $range
#     $range = $null
#     $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet)
#     $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
#     $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)

# }

# Exercises the target of the test - the get-process cmdlet
# and responds with a pre-defined set of responses that were
# on the worksheet as the expected results
# "TestCase","Remark","Method","Command","Parameter","Value"
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