# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

#
# Tests the AssertThrows function
# All assertions with label suffix "-test" should PASS
function TestAssertThrows
{
	$a = {get-wmiobject Win32_OperatingSystem -property ServicePackMajorVersion -computer nolaptop -ea stop }
	$msg = "0x800706BA"
#	AssertThrows System.Management.Automation.ActionPreferenceStopException $msg $a "TC-22a"
	AssertThrows System.Runtime.InteropServices.COMException $msg $a "TC-22a"
	AssertEqual $ResultPrefix.Passed  $Assertions[0].Result "TC-22a-decision-test"
	RaiseAssertions

	$a = {get-wmiobject Win32_OperatingSystem -property ServicePackMajorVersion -ea stop }
	AssertThrows System.Exception Fred $a "TC-22b" -Intent $Intention.ShouldFail
	AssertEqual $ResultPrefix.Failed $Assertions[0].Result  "TC-22b-decision-test"
	AssertEqual $AssertThrowsNoExceptionThrownMessage $Assertions[0].Message "TC-22b-msg-test"
	RaiseAssertions

	$a = {get-wmiobject Win32_OperatingSystem -property ServicePackMajorVersion -computer nolaptop -ea stop }
	AssertThrows System.Exception Fred $a "TC-22c" -Intent $Intention.ShouldFail
	AssertEqual $ResultPrefix.Failed $Assertions[0].Result "TC-22c-decision-test"
	RaiseAssertions
	
	$a = {get-wmiobject Win32_OperatingSystem -property ServicePackMajorVersion -computer nolaptop -ea stop }
	$a | AssertThrows -ExceptionExpected System.Exception -MessageExpectedRegExpr Fred -Label "TC-22d" -Intent $Intention.ShouldFail
	AssertEqual "TC-22d-ExceptionType" $Assertions[0].Label "TC-22d-label-type-test"
	AssertEqual "TC-22d-ExceptionMessage" $Assertions[1].Label "TC-22d-label-msg-test"
	AssertEqual $ResultPrefix.Failed $Assertions[0].Result "TC-22d-decision-test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestAssertThrows
