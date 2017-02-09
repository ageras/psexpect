# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the Assert function
# All assertions with label suffix "-test" should PASS
function TestLogging
{
	# this test doesn't run cleanly unless you evaluate all of the test conditions
    if (Test-Path variable:TestConditionFilter) { 	$originalFilter = $TestConditionFilter }
    if (Test-Path variable:LogFileName) { 	$originalLogFileName = $LogFileName }

	$TestConditionFilter = $null
	
	# start from a known state - delete the log file
	# then evaluate some test conditions with the side effect of creating the log file
	remove-item $LogFileName
	Assert (1 -eq 1) -Label "TC-Log-1"
	AssertEqual 1 1 -Label "TC-Log-2"
	RaiseAssertions

	# assert that the results from the test conditions above are found in the log file	
	$s = get-content $LogFileName
	$lastEntry = $s.length
	AssertMatch $s[$lastEntry - 1] $ResultPrefix.Passed "TC-Log-2-decision-test"
	AssertMatch $s[$lastEntry - 1] "TC-Log-2" "TC-Log-2-label-test"
	RaiseAssertions

	# assert that the file grows by one line when a test condition is evaluated
	$s = $null
	$s = get-content $LogFileName
	$before = $s.length
	Assert (1 -eq 1) -Label "TC-Log-3"
	$s = $null
	$s = get-content $LogFileName
	$after = $s.length
	$expectedAfter = [Int32]($before + 1)
	AssertEqual $expectedAfter $after "TC-Log-3-length-test"
	RaiseAssertions
	
	$s=$null
	
	AssertEqual 1 2 -Label "TC-Log-4" -Intent $Intention.ShouldFail
	
	$s = get-content $LogFileName
	$lastEntry = $s.length
	AssertMatch $s[$lastEntry - 1] $ResultPrefix.Failed "TC-Log-4-decision-test"
	AssertMatch $s[$lastEntry - 1] "TC-Log-4" "TC-Log-4-label-test"
	AssertMatch $s[$lastEntry - 1] $AssertEqualConjunction "TC-Log-4-msg-test"
	RaiseAssertions

	# assert that logging can be turned off by setting $LogFileName to $null
	$LogFile = $originalLogFileName
	$s = get-content $originalLogFileName
	$before = $s.length
	$s = $null
	$LogFileName = $null
	AssertEqual 1 1 -Label "TC-Log-5"
	$s = get-content $originalLogFileName
	$after = $s.length
	AssertEqual $before $after "TC-Log-5-decision-test"
	RaiseAssertions
		
    if (Test-Path variable:originalLogFileName) { $LogFileName = $originalLogFileName }
    if (Test-Path variable:originalFilter) { $TestConditionFilter = $originalFilter }
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestLogging
