# Copyright 2025 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#region GlobalVariables
$Global:_XLLIB = "_XLLIB"
$Global:ciUS = [System.Globalization.CultureInfo]'en-US'
#endregion

#
# Generic function for running any Excel-based test scenario
# The RangeName parameter must be the name of the range where the test data is stored
# and also it must be the name of the test fixture to call for each row
#
function global:Start-Test
{
    param(
        [string]$Path, 
        $Function, 
        $Parameters
    )

    # retrieve the contents of the range
    # $rangeAsList = select-row $WorkbookName $WorksheetName $RangeName $FieldNames
    $rangeAsList = Import-Csv -Path $Path
    if ($null -eq $rangeAsList) { return $null}

    write-host "There are" $rangeAsList.Count "test cases"

    foreach ($item in $rangeAsList) {

        Invoke-Command $Function -ArgumentList @($item.($Parameters[0])), @($item.($Parameters[1])), @($item.($Parameters[2])), @($item.($Parameters[3])), @($item.($Parameters[4])), @($item.($Parameters[5])), @($item.($Parameters[6])), @($item.($Parameters[7])), @($item.($Parameters[8]))
    }

    # display the results of the assertions    
    RaiseAssertions

}
