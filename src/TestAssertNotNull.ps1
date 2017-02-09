# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertNotNull function
# All assertions with label suffix "-test" should PASS
function TestAssertNotNull
{
	$ctnstr = "Not a null object"
	AssertNotNull $ctnstr "TC-19a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-19a-decision-test"
	RaiseAssertions

    $newvar = $null
	AssertNotNull $newvar "TC-19b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-19b-decision-test"
	AssertMatch $Assertions[0].Message $AssertNotNullFailedMessage "TC-19b-msg-test"
	RaiseAssertions
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertNotNull
$errorview=$null
