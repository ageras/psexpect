# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Demonstrates the Collect function
function TestSelectRow
{
    # specify the range location including workbook, worksheet, range
    $theFolder = get-location
    $WorkbookName = $theFolder.ToString() + "\TimeEntryConfig.xls"
    $WorksheetName = "Worksheet1"
    $RangeName = "Projects"

    # specify how to reference the row contents
    $FieldNames = "Code","Description"

    # retrieve the contents of the range
    $rangeAsList = select-row $WorkbookName $WorksheetName $RangeName $FieldNames

    AssertNotNull $rangeAsList "TC-1"
    AssertEqual 12 $rangeAsList.Count -Label "TC-2"
    AssertEqual "tc" $rangeAsList[0].Code "TC-3"
    AssertEqual "Project TC" $rangeAsList[0].Description "TC-4"

    $rangeAsList = select-row $null $WorksheetName $RangeName $FieldNames
    AssertNull $rangeAsList "TC-5"

    $rangeAsList = select-row $WorkbookName $null $RangeName $FieldNames
    AssertNull $rangeAsList "TC-6"

    $rangeAsList = select-row $WorkbookName $WorksheetName $null $FieldNames
    AssertNull $rangeAsList "TC-7"
           
    $rangeAsList = select-row $WorkbookName $WorksheetName $RangeName $null
    AssertNull $rangeAsList "TC-8"

    $rangeAsList = select-row ($theFolder.ToString() + "\NotValid.xls") $WorksheetName $RangeName $FieldNames
    AssertNull $rangeAsList "TC-9"

    $rangeAsList = select-row $WorkbookName $WorksheetName $RangeName @()
    AssertNull $rangeAsList "TC-10"

    RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestSelectRow
