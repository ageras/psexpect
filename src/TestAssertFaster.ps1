# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertFaster function
# All assertions with label suffix "-test" should PASS
function TestAssertFaster
{
	$a = {Get-Service | Export-Clixml test.xml}
	AssertFaster 10000 $a "TC-23a"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-23a-decision-test"
	RaiseAssertions

	$a = {Get-Service | Export-Clixml test.xml}
	AssertFaster 1 $a "TC-23b" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-23b-decision-test"
	RaiseAssertions

	$a = {Get-Service | Export-Clixml test.xml}
	$a | AssertFaster -MaximumTime 10000 -Label "TC-23c"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-23c-decision-test"
	RaiseAssertions

	remove-item test.xml
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertFaster
$errorview=$null
