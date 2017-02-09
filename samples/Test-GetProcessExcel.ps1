# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Demonstrates the Collect function
function TestGetProcessFromExcel
{

    # specify the range location including workbook, worksheet, range
    $theFolder = get-location
    $WorkbookFullPath = $theFolder.ToString() + "\TestGetProcessFromExcel.xls"

    # if this worksheet name doesn't exist in the workbook, the error is ugly
    # and Excel is left orphaned and running in the background
    $WorksheetName = "Sheet1"

    # ditto for the range - if the name doesn't exist, the error is ugly
    # and Excel is left orphaned and running in the background
    $RangeName = "TestGetProcessFixture"

    # specify how to reference the row contents
    # this isn't read from the worksheet so that the tester has control over how 
    # the columns are referenced in the rest of the script
    $FieldNames = "TestCase","Remark","ProcessName","ShouldExist"

    # retrieve the contents of the range
    $rangeAsList = select-row $WorkbookFullPath $WorksheetName $RangeName $FieldNames

    # make sure it's not null
    AssertNotNull $rangeAsList "GPSXL-1"

    # for each row in the test cases range,
    foreach ($item in $rangeAsList) {

        # exercise the target of the test
        $proc = TestGetProcessFixture $item.ProcessName

        # check the actual results against the expected results on the worksheet
        # and use the label from the worksheet's first column 
        AssertEqual $proc $item.ShouldExist $item.TestCase

    }
    RaiseAssertions

}

# Exercises the target of the test - the get-process cmdlet
# and responds with a pre-defined set of responses that were
# on the worksheet as the expected results
function TestGetProcessFixture([string]$ProcessName)
{
    if ($ProcessName -eq $null) {return "FALSE"}
    $result = "TRUE"
    $proc = get-process $ProcessName
    if ($proc -eq $null) {
        $result = "FALSE"
    }
    return $result
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestGetProcessFromExcel
