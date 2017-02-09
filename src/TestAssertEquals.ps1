# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertEquals function
# All assertions with label suffix "-test" should PASS
function TestAssertEquals
{
	$e = [Int32]12
	$a = [Int32]12
	AssertEqual $e $a "TC-4i"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-4i-test"
	RaiseAssertions
	
	AssertEqual This This "TC-4s"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-4s-test"
	RaiseAssertions

	$e = [Double]1.1
	$a = [Double]1.1
	AssertEqual 1.1 1.1 "TC-4d"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-4d-test"
	RaiseAssertions

	$e = [Float]12
	$a = [Float]14
	AssertEqual 1.1 1.1 "TC-4f"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-4f-test"
	RaiseAssertions

	$e = new-object System.Collections.ArrayList
	$a = new-object System.Collections.ArrayList

	$added = $e.Add("this")
	$added = $a.Add("this")

	AssertEqual $e $a "TC-4o"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-4o-test"
	RaiseAssertions

	AssertEqual $null $null "TC-4n1"
	AssertEqual $Assertions[0].Result $ResultPrefix.Passed "TC-4n1-test"
	RaiseAssertions

	AssertEqual $null "this" "TC-4n2" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-4n2-test"
	RaiseAssertions

	AssertEqual "this" $null "TC-4n3" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-4n3-test"
	RaiseAssertions

	$e = [Int32]12
	$a = [Int32]14
	AssertEqual $e $a "TC-104i" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-104i-test"
	RaiseAssertions

	AssertEqual this that "TC-104s" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-104s-test"
	RaiseAssertions


	$e = [double]1.1
	$a = [double]1.2
	AssertEqual $e $a "TC-104d" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-104d-test"
	RaiseAssertions

	$e = [float]1.1
	$a = [float]1.2
	AssertEqual $e $a "TC-104f" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-104f-test"
	RaiseAssertions

	$e = new-object System.Collections.ArrayList
	$a = new-object System.Collections.ArrayList

	$added = $e.Add("this")
	$added = $a.Add("that")

	AssertEqual $e $a "TC-104o" -Intent $Intention.ShouldFail
	AssertEqual $Assertions[0].Result $ResultPrefix.Failed "TC-104o-test"
	RaiseAssertions
	
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
$errorview="CategoryView"
TestAssertEquals
$errorview=$null
