# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

function RegisterActivity
{
    param([string]$Name, [string]$Description, [string]$Added, [string]$ExpectedReason)

    $CalculatedReason = $Name + $Description + $Added
    AssertEqual $ExpectedReason $CalculatedReason -Label $Name -Intent $Intention.ShouldPass 

}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$FieldNames = ("Name","Description","Added","Reason")
start-test ((get-location).ToString() + "\TimeEntryConfig.xls") "Worksheet1" "RegisterActivity" $FieldNames
