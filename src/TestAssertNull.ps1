# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertNull function
# All assertions with label suffix "-test" should PASS
function TestAssertNull
{
    $newvar = $null
	AssertNull $newvar "TC-18a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-18a-decision-test"
	RaiseAssertions

	$ctnstr = "Not a null object"
	AssertNull $ctnstr "TC-18b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-18b-decision-test"
	AssertEqual $Assertions[0].Message $AssertNullFailedMessage "TC-18b-msg-test"
	RaiseAssertions
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertNull
$errorview=$null
