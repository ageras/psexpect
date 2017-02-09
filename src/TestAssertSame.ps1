# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertSame function
# All assertions with label suffix "-test" should PASS
function TestAssertSame
{
	$a = new-object System.Collections.Arraylist
	$b = $a
	AssertSame $a $b "TC-20a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-20a-decision-test"
	RaiseAssertions

	$a = new-object System.Collections.Arraylist
	$b = new-object System.Collections.Arraylist
	AssertSame $a $b "TC-20b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-20b-decision-test"
	AssertEqual $Assertions[0].Message $AssertSameFailedMessage "TC-20b-msg-test"
	RaiseAssertions

	AssertSame $null $b "TC-20c" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-20c-decision-test"
	AssertEqual $Assertions[0].Message $AssertSameFailedMessage "TC-20c-msg-test"
	RaiseAssertions

	AssertSame $a $null "TC-20d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-20d-decision-test"
	AssertEqual $Assertions[0].Message $AssertSameFailedMessage "TC-20d-msg-test"
	RaiseAssertions

	AssertSame $null $null "TC-20e"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-20e-decision-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestAssertSame
