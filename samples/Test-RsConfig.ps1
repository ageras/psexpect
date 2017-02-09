# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0
$targetcomputer = "localhost"
$rs = get-wmiobject -computer $targetcomputer -namespace "root\Microsoft\SqlServer\ReportServer\v9\Admin" MSReportServer_ConfigurationSetting

# Exercises the target of the test - the 
# and responds with a pre-defined set of responses that were
# on the worksheet as the expected results
function TestRsConfig()
{
    param([string]$TestCase, [string]$RsConfigProperty, [string]$ExpectedValue)

    $ActualValue = $rs.PSBase.GetPropertyValue($RsConfigProperty).ToString()
    if ([string]::IsNullOrEmpty($ActualValue)) {$ActualValue = $null}

    if ($ExpectedValue.Trim() -eq "N/C")
    {
        AssertNull $ActualValue -Label $TestCase -Intention $Intention.ShouldPass    
    }
    else 
    {
        AssertEqual $ExpectedValue $ActualValue -Label $TestCase -Intention $Intention.ShouldPass
    }

    RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

. ..\samples\RsLib.ps1

# Configuration and installation testing ...
# Confirm the Reporting Services configuration matches expectations documented in 
# the Excel workbook 'TestRsConfig.xslx'
write-host "Configuration testing ..."
$FieldNames = ("TestCase", "RsConfigProperty", "ExpectedValue")
start-test ((get-location).ToString() + "\TestRsConfig.xlsx") "Sheet1" `
    "TestRsConfig" $FieldNames

# Functional testing ...
# Verify datasource create/delete functionality
write-host "Functional testing ..."
$DsBefore = get-datasourcecount
new-datasource -Name "FromPsScript"
test-datasourcecount -Expected ($DsBefore + 1) -Label "Datasources.Count.AfterNew"
remove-datasource -Name "FromPsScript"
test-datasourcecount -Expected ($DsBefore) -Label "Datasources.Count.AfterRemove"

# Verify the report create/delete functionality
$RsBefore = get-reportcount
new-report -Name "ReportFromPsScript"
test-reportcount -Expected ($RsBefore + 1) -Label "Reports.Count.AfterNew"
remove-report -Name "ReportFromPsScript"
test-reportcount -Expected $RsBefore -Label "Reports.Count.AfterRemove"

# To Do
# Verify the report rendering functionality
#render-report -Name "Company Sales" -Format "HTML" -Path "Company Sales Actual"
#test-report -Expected "Company Sales Reference" -Actual "Company Sales Actual"

RaiseAssertions
