# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertInstanceOf function
# All assertions with label suffix "-test" should PASS
function TestAssertInstanceOf
{
	AssertInstanceOf Int32 1 "TC-8a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-8a-decision-test"
	RaiseAssertions

	AssertInstanceOf String "This is a test" "TC-8b"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-8b-decision-test"
	RaiseAssertions

	AssertInstanceOf Double 23.1 "TC-8c"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-8c-decision-test"
	RaiseAssertions

	AssertInstanceOf Int32 2.1 "TC-8d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-8d-decision-test"
	RaiseAssertions
	
	AssertInstanceOf String 2 "TC-8e" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-8e-decision-test"
	RaiseAssertions

	AssertInstanceOf String $null "TC-8f" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-8f-decision-test"
	RaiseAssertions
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertInstanceOf
$errorview=$null
