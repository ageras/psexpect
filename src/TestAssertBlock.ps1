# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Tests the Assert-Block function
# All assertions with label suffix "-test" should PASS
function TestAssertBlock
{
	$cmsg = "This message should not appear in the output."
	Assert-Block{$true} -Label "TC-0a" -Message $cmsg
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-0a-decision-test"
	AssertNoMatch $Assertions[0].Message $cmsg "TC-0a-msg-test"
	RaiseAssertions

	$cmsg = "This message should appear in the output."
	Assert-Block{$false} -Label "TC-0b" -Message $cmsg -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-0b-decision-test"
	AssertEqual $Assertions[0].Message $cmsg "TC-0b-msg-test"
	RaiseAssertions

    $block = {1 -eq 1}
    $block | Assert-Block -Label "TC-0c"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-0c-decision-test"
	AssertEqual $Assertions[0].Label "TC-0c" "TC-0c-label-test"
    RaiseAssertions

    $block = {1 -eq 2}
    $block | Assert-Block -Label "TC-0d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-0d-decision-test"
	AssertEqual $Assertions[0].Label "TC-0d" "TC-0d-label-test"
	AssertNull $Assertions[0].Message "TC-0d-message-test"
    RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestAssertBlock
