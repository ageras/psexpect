# Copyright 2006 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Tests the Collect function
function TestCollect
{

    # describe your workbook and the data that is on it
    $folder = get-location
    $WorkbookName = $folder.ToString() + "\TimeEntryConfig.xls"
    $WorksheetName = "Worksheet1"
    $RangeName = "Projects"
    $FieldNames = "Code","Description"
    
    # start Excel
    $excel = new-object -comobject Excel.Application

    # get the data
    $fileExists = test-path $workbookname
    if (!$fileExists) { return $null }

    $workbook = open-workbook $excel $workbookname
    if ($workbook -eq $null) { return "Failed to open the specified workbook." }

    $worksheet = get-worksheet $workbook $WorksheetName
    if ($worksheet -eq $null) { return "Failed to find the specified worksheet." }

    $range = get-range $worksheet $RangeName
    if ($range -eq $null) { return "Failed to find the specified range." }

    # retrieve the contents of the range as a list    
    $rangeAsList = collect-range $range $FieldNames
    if ($rangeAsList -eq $null) { return "Unable to access the specified range." }

    # ensure the returned hashtable is not null
    AssertNotNull $rangeAsList "TC-Collect-1-test"

    # ensure the returned container hashtable contains all the rows in the specified range
    AssertEqual 12 $rangeAsList.Count "TC-Collect-2-test"

    # ensure the two fields can be referenced and have the values we expect
    AssertEqual "tc" $rangeAsList[0].Code "TC-Collect-3-test"
    AssertEqual "Project TC" $rangeAsList[0].Description  "TC-Collect-4-test"

    RaiseAssertions

    # this is how you ensure that your COM object actually quits - release every COM-related variable
    $excel.Quit()
    $a = release-range $range
    $range = $null
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet)
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)

}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { .\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestCollect
