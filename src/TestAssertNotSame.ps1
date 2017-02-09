# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertNotSame function
# All assertions with label suffix "-test" should PASS
function TestAssertNotSame
{
	$a = new-object System.Collections.Arraylist
	$b = new-object System.Collections.Arraylist
	AssertNotSame $a $b "TC-21a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-21a-decision-test"
	RaiseAssertions

	$b = $a
	AssertNotSame $a $b "TC-21b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-21b-decision-test"
	AssertEqual $Assertions[0].Message $AssertNotSameFailedMessage "TC-21b-msg-test"
	RaiseAssertions
	
	$b = $null
	AssertNotSame $a $b "TC-21c"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-21c-decision-test"
	RaiseAssertions

	$b = $null
	AssertNotSame $b $a "TC-21d"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-21d-decision-test"
	RaiseAssertions

	AssertNotSame $null $null "TC-21e" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-21e-decision-test"
	AssertEqual $Assertions[0].Message $AssertNotSameFailedMessage "TC-21e-msg-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertNotSame
$errorview=$null
