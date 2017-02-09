# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Tests the Assert function
# All assertions with label suffix "-test" should PASS
function TestAssert
{

    write-host "Testing output colourization ... expect green, yellow and red console output."
    # passing test condition with label
	Assert (1 -eq 1) -Label "TC-1"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-1-decision-test"
	AssertEqual $Assertions[0].Label "TC-1" "TC-1-label-test"
	RaiseAssertions

    # passing test condition without a label
    Assert (1 -eq 1) 
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-1a-decision-test" 
    RaiseAssertions

    # failing test condition with label, marked as expected to fail
	$IsTrue = (1 -eq 2)
	Assert $IsTrue -Label "TC-101-Should be in YELLOW" $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-101-decision-test"
	AssertEqual $Assertions[0].Intent $Intention.ShouldFail "TC-101-flag-test"
	AssertEqual $Assertions[0].Label "TC-101-Should be in YELLOW" "TC-101-label-test"
	AssertEqual $Assertions[0].Message $AssertFailedMessage "TC-101-msg-test"
	RaiseAssertions
	
    # failing test condition with label, default is marked as expected to pass
	$IsTrue = (1 -eq 2)
	Assert $IsTrue -Label "TC-102-Should be in RED"
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-102-decision-test"
	AssertEqual $Assertions[0].Intent $Intention.ShouldPass "TC-102-flag-test"
	AssertEqual $Assertions[0].Message $AssertFailedMessage "TC-102-msg-test"
	RaiseAssertions

    # failing test condition with label, explicitly marked as expected to pass
	$IsTrue = (1 -eq 2)
	Assert $IsTrue -Label "TC-103-Should be in RED" $Intention.ShouldPass
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-103-decision-test"
	AssertEqual $Assertions[0].Intent $Intention.ShouldPass "TC-103-flag-test"
	AssertEqual $Assertions[0].Message $AssertFailedMessage "TC-103-msg-test"
	RaiseAssertions

    # passing test condition with label, explicitly marked as expected to fail
	$IsTrue = (1 -eq 1)
	Assert $IsTrue -Label "TC-104-Should be in RED" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-104-decision-test"
	AssertEqual $Assertions[0].Intent $Intention.ShouldFail "TC-104-flag-test"
    AssertEqual $Assertions[0].Message "Expected 'FAILED' but was 'PASSED'." "TC-104-extended-msg-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestAssert
