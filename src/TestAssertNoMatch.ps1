# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertNoMatch function
# All assertions with label suffix "-test" should PASS
function TestAssertNoMatch
{
	$ctnstr ="This is a test from 1979"

	AssertNoMatch $ctnstr "196" "TC-12a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-12a-decision-test"
	RaiseAssertions
	
	AssertNoMatch $ctnstr "197" "TC-12b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-12b-decision-test"
	AssertMatch $Assertions[0].Message $AssertNoMatchFailedPrefix "TC-12b-msg-test"
	RaiseAssertions
	
	AssertNoMatch $null "197" "TC-12c"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-12c-decision-test"
	RaiseAssertions

	AssertNoMatch $ctnstr $null "TC-12d"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-12d-decision-test"
	RaiseAssertions

	AssertNoMatch $null $null "TC-12e" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-12e-decision-test"
	AssertMatch $Assertions[0].Message "empty" "TC-12e-msg-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertNoMatch
$errorview=$null
