# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertMatch function
# All assertions with label suffix "-test" should PASS
function TestAssertMatch
{
	$ctnstr ="This is a test from 1979"
	AssertMatch $ctnstr "197?" "TC-11a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-11a-decision-test"
	RaiseAssertions
	
	AssertMatch $ctnstr "196" "TC-11b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-11b-decision-test"
	AssertMatch $Assertions[0].Message $AssertMatchFailedPrefix "TC-11b-msg-test"
	RaiseAssertions
	
	AssertMatch $null "196" "TC-11c" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-11c-decision-test"
	AssertMatch $Assertions[0].Message "empty" "TC-11c-msg-test"
	RaiseAssertions

	AssertMatch $ctnstr $null "TC-11d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-11d-decision-test"
	AssertMatch $Assertions[0].Message "empty" "TC-11d-msg-test"
	RaiseAssertions

	AssertMatch $null $null "TC-11e"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-11e-decision-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertMatch
$errorview=$null
