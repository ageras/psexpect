# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#region GlobalVariables
$Global:_XLLIB = "_XLLIB"
$Global:ciUS = [System.Globalization.CultureInfo]'en-US'
#endregion

# The Collect-Range method retrieves the specified range from Excel
# and returns it as a list of hashtables, one for each row.
# 
# $Range - System.Object[], returned via a call to the Excel Range method
# $FieldNames - names to use as labels for each column (keys of the hashtable for each row)
#
function global:Collect-Range()
{
    param($Range, $FieldNames)

    $colCount = $FieldNames.GetUpperBound(0) + 1
    $rowCount = [int] (($Range.GetUpperBound(0) + 1) / $colCount)

    # build the containing list
    $rangeAsList = new-object System.Collections.ArrayList

    for($rowindex = 0; $rowindex -lt $rowCount; $rowindex++) {
        # build the hashtable that will contain this row
        $contentsHash = @{}
        for($colindex = 0; $colindex -lt $colCount; $colindex++) {
            $elem = ($rowindex * $colCount) + $colindex
            $contentsHash.Add(($FieldNames[($colindex)]),(GetProperty $Range[$elem] "Value"))
            $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($Range[$elem])
        }
        $added = $rangeAsList.Add($contentsHash)
    }

    return $rangeAsList
    
}

# The Select-Row method returns a list of the rows in the specified
# Excel range.  Each row is a hashtable that is keyed using the specified
# field names.
#
# WorkbookName - the full path to the Excel workbook (required)
# WorksheetName - the name of the Worksheet within the workbook (required)
# RangeName - the name of the Range within the worksheet (required)
# FieldNames - collection of names to use for referencing the column values (required)
#
function global:Select-Row()
{
    param([string]$WorkbookName, [string]$WorksheetName, [string]$RangeName, $FieldNames)

    if ([string]::IsNullOrEmpty($WorkbookName))
    {
        write-host "Workbook name cannot be null or empty."
        return $null
    }

    $fileExists = test-path $WorkbookName
    if (!$fileExists)
    {
        write-host "Workbook doesn't exist..." 
        return $null 
    }

    if ([string]::IsNullOrEmpty($WorksheetName))
    {
        write-host "Worksheet name cannot be null or empty."
        return $null
    }

    if ([string]::IsNullOrEmpty($RangeName))
    {
        write-host "Range name cannot be null or empty."
        return $null
    }

    if (($FieldNames -eq $null) -or ($FieldNames.Count -eq 0))
    {
        write-host "Field names cannot be null or empty."
        return $null
    }

    $excel = New-Object -comobject Excel.Application
    $workbook = open-workbook $excel $WorkbookName
    $worksheet = get-worksheet $workbook $WorksheetName
    $range = get-range $worksheet $RangeName

    $rangeAsList = collect-range $range $FieldNames

    $excel.Quit()
    $a = release-range $range
    $range = $null
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet)
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($excel)

    return $rangeAsList
}

#
# Using Excel successfully from computers not running as 'en-US'
#
function global:Invoke()
{
    param([object]$target, [string]$method, $parameters)

    # invoke using reflection
    $result = $target.PSBase.GetType().InvokeMember($method, [Reflection.BindingFlags]::InvokeMethod, $null, $target, $parameters, $ciUS)

    # clean up and return
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($target)
    return $result    
}

#
# Using Excel successfully from computers not running as 'en-US'
#
function global:GetProperty()
{
    param([object]$target, [string]$property, $parameters)

    # invoke using reflection
    $result = $target.PSBase.GetType().InvokeMember($property, [Reflection.BindingFlags]::GetProperty, $null, $target, $parameters, $ciUS)

    # clean up and return
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($target)
    return $result
}

#
# Using Excel successfully from computers not running as 'en-US'
#
function global:SetProperty()
{
    param([object]$target, [string]$property, $parameters)

    # invoke using reflection
    $result = $target.PSBase.GetType().InvokeMember($property, [Reflection.BindingFlags]::SetProperty, $null, $target, $parameters, $ciUS)

    # clean up and return
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($target)
    return $result
}

#
# Opens the specified workbook using the Excel application object
#
function global:Open-Workbook()
{
    param ($excel, [string]$workbookname)

    $fileExists = test-path $workbookname
    if (!$fileExists) { return $null }
    $result = Invoke $excel.Workbooks "Open" $workbookname
    return $result
}

#
# Returns the specified worksheet in the specified workbook
#
function global:Get-Worksheet()
{
    param($workbook, [string]$worksheetname)

    $result = GetProperty $workbook.Worksheets "Item" $worksheetname

    # clean up and return
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($workbook)
    return $result
}

#
# Returns the specified range on the specified worksheet as 
# a single-dimension System.Object[] - not sure why it does this,
# but that is the default observed behaviour in calling the Range
# property of the Excel worksheet object
#
function global:Get-Range()
{
    param($worksheet, [string]$rangename)

    $result = GetProperty $worksheet "Range" $rangename

    # clean up and return
    $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($worksheet)
    return $result
}

function global:Release-Range()
{
    param([System.Object[]] $range)

    for ($elemindex = 0; $elemindex -le $range.GetUpperBound(0); $elemindex++)
    {
        $a = [System.Runtime.InteropServices.Marshal]::ReleaseComObject($range[$elemindex])
    }
}

#
# Generic function for running any Excel-based test scenario
# The RangeName parameter must be the name of the range where the test data is stored
# and also it must be the name of the test fixture to call for each row
#
function global:Start-Test
{
    param([string]$WorkbookName, [string]$WorksheetName, [string]$RangeName, $FieldNames)

    # retrieve the contents of the range
    $rangeAsList = select-row $WorkbookName $WorksheetName $RangeName $FieldNames
    if ($rangeAsList -eq $null) { return $null}
    write-host "There are" $rangeAsList.Count "test cases"
    foreach ($item in $rangeAsList) {

        # exercise the target of the test by building a command string and then invoking it
        $strExec = $RangeName
        foreach ($col in $FieldNames)
        {
            $strExec += " '" + [string]$item[$col] + "'"
        }
        invoke-expression $strExec

    }

    # display the results of the assertions    
    RaiseAssertions

}
