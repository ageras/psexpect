# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertNotEqual function
# All assertions with label suffix "-test" should PASS
function TestAssertNotEqual
{
	$e = [Int32]12
	$a = [Int32]14
	AssertNotEqual $e $a "TC-15i"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-15i-decision-test"
	RaiseAssertions

	AssertNotEqual "This" "That" "TC-15s"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-15s-decision-test"
	RaiseAssertions

	$e = [double]1.1
	$a = [double]1.2
	AssertNotEqual $e $a "TC-15d"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-15d-decision-test"
	RaiseAssertions

	$e = [float]1.1
	$a = [float]1.2
	AssertNotEqual $e $a "TC-15f"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-15f-decision-test"
	RaiseAssertions

	$e = new-object System.Collections.ArrayList
	$a = new-object System.Collections.ArrayList
	$added = $e.Add("this")
	$added = $a.Add("that")
	AssertNotEqual $e $a "TC-15o"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-15o-decision-test"
	RaiseAssertions

	$e = [Int32]12
	$a = [Int32]12
	AssertNotEqual $e $a "TC-115i" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-115i-decision-test"
	RaiseAssertions

	AssertNotEqual This This "TC-115s" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-115s-decision-test"
	RaiseAssertions

	$e = [double]1.1
	$a = [double]1.1
	AssertNotEqual $e $a "TC-115d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-115d-decision-test"
	RaiseAssertions

	$e = [float]1.1
	$a = [float]1.1
	AssertNotEqual $e $a "TC-115f" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-115f-decision-test"
	RaiseAssertions
	
	$e = new-object System.Collections.ArrayList
	$a = new-object System.Collections.ArrayList
	$added = $e.Add("this")
	$added = $a.Add("this")
	AssertNotEqual $e $a "TC-115o" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-115o-decision-test"
	RaiseAssertions

	AssertNotEqual $e $null "TC-115n1"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-115n1-decision-test"
	RaiseAssertions

	AssertNotEqual $null $a "TC-115n2"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-115n2-decision-test"
	RaiseAssertions

	AssertNotEqual $null $null "TC-115n3" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-115n3-decision-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertNotEqual
$errorview=$null
