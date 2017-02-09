# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Exercises the target of the test - the running certain performance counters
# and comparing the results to an expected range of values.
#
# Important - there is no "dash" in the function name because in Excel, a range name
# cannot use that character, and we are using the range name as equivalent to the 
# function name.
#
function TestResource()
{
    # these parameters must match the order of the cells in the table in Excel
    param([string]$TestCase, [string]$Remark, [string]$PerfObject, [string]$PerfCounter, [string]$Instance, $Duration, $Interval, $LowThreshold, $HighThreshold)

    write-host $TestCase $Remark $PerfObject $PerfCounter $Instance
    $pc = new-object System.Diagnostics.PerformanceCounter $PerfObject,$PerfCounter,$Instance
    AssertNotNull $pc -Label $TestCase

    if ($pc -ne $null) 
    {
        for($i=1;$i -le $Duration;$i++)
        {
            $count = $pc.NextValue()
            Assert ($count -ge $LowThreshold) -label ($TestCase + "-low") -intent $Intention.ShouldPass
            Assert ($count -le $HighThreshold) -label ($TestCase + "-high") -intent $Intention.ShouldPass
            RaiseAssertions
            start-sleep -m $Interval
        }
    }
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the function test function above for each row in the Excel range using the generic Perform-Test
# function that is defined in DataLib.ps1
$FieldNames = ("TestCase","Remark","PerfObject","PerfCounter","Instance","Duration","Interval", "LowThreshold","HighThreshold")
start-test ((get-location).ToString() + "\TestResource.xls") "Sheet1" "TestResource" $FieldNames