# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertContains function
# All assertions with label suffix "-test" should PASS
function TestAssertContains
{

	$c = "red", "blue"
	$services = get-service
	foreach ($s in $services) { $c = $c + $s.Name }
	AssertContains $c $services[2].Name -Label "TC-24a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-24a-decision-test"
	RaiseAssertions

	$invalidServiceName = "sjshdfgs"
	AssertContains $c $invalidServiceName -Label "TC-24b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-24b-decision-test"
	AssertEqual $Assertions[0].Message $AssertContainsFailedMessage "TC-24b-msg-test"
	RaiseAssertions
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestAssertContains
