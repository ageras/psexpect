# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertInTolerance function
# All assertions with label suffix "-test" should PASS
function TestAssertInTolerance
{
	AssertInTolerance 2.1 2.2 0.1 "TC-5a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-5a-decision-test"
	RaiseAssertions

	AssertInTolerance 2.1 2.2 -0.1 "TC-5b"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-5b-decision-test"
	RaiseAssertions

	AssertInTolerance 2.1 2.1 0 "TC-5c"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-5c-decision-test"
	RaiseAssertions

	AssertInTolerance 2.1 2.2 0.001 "TC-5d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-5d-decision-test"
	RaiseAssertions

	AssertInTolerance -2 -3 0.5 "TC-5e" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-5e-decision-test"
	RaiseAssertions

	AssertInTolerance $null -3 0.5 "TC-5f" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-5f-decision-test"
	RaiseAssertions

	AssertInTolerance -2 $null 0.5 "TC-5g" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-5g-decision-test"
	RaiseAssertions

	AssertInTolerance -2 -3 $null "TC-5h" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-5h-decision-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertInTolerance
$errorview=$null
