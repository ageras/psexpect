# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the RaiseAssertions function
# All assertions with label suffix "-test" should PASS
# NOTE - not testing raising/displaying only matching assertion results
function TestRaiseAssertions
{
	# this test doesn't run cleanly unless you evaluate all of the test conditions
    if (Test-Path variable:TestConditionFilter) { 	$originalFilter = $TestConditionFilter }

	$TestConditionFilter = $null

	$Assertions.Clear()
	AssertEqual 0 $Assertions.Count TC-Raise-1-test
	AssertEqual 1 $Assertions.Count TC-Raise-2-test
	RaiseAssertions
	AssertEqual 0 $Assertions.Count TC-Raise-3-test
	RaiseAssertions
	
    if (Test-Path variable:originalFilter) { $TestConditionFilter = $originalFilter }

}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestRaiseAssertions
$errorview=$null
