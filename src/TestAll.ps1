# Copyright 2006 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

function TestAll
{

	# results of assertions are not displayed until raised using the RaiseAssertions function
	RaiseAssertions
	write-host "Testing AssertBlock..."
	.\TestAssertBlock.ps1
	write-host "Finished testing AssertBlock."
	
	RaiseAssertions
	write-host "Testing Assert..."
	.\TestAssert.ps1
	write-host "Finished testing Assert."

	RaiseAssertions
	write-host "Testing AssertEquals..."
	.\TestAssertEquals.ps1
	write-host "Finished testing AssertEquals."
		
	RaiseAssertions
	write-host "Testing AssertInTolerance..."
	.\TestAssertInTolerance.ps1
	write-host "Finished testing AssertInTolerance."
	
	RaiseAssertions
	write-host "Testing AssertInstanceOf..."
	.\TestAssertInstanceOf.ps1
	write-host "Finished testing AssertInstanceOf."

	RaiseAssertions
	write-host "Testing AssertMatch..."	
	.\TestAssertMatch.ps1
	write-host "Finished testing AssertMatch."

	write-host "Testing AssertNoMatch..."
	.\TestAssertNoMatch.ps1
	write-host "Finished testing AssertNoMatch."

	write-host "Testing AssertNotEqual..."
	.\TestAssertNotEqual.ps1
	write-host "Finished testing AssertNotEqual."

	write-host "Testing AssertNull..."
	.\TestAssertNull.ps1
	write-host "Finished testing AssertNull."

	write-host "Testing AssertNotNull..."
	.\TestAssertNotNull.ps1
	write-host "Finished testing AssertNotNull."

	write-host "Testing AssertSame..."	
	.\TestAssertSame.ps1
	write-host "Finished testing AssertSame."

	write-host "Testing AssertNotSame..."		
	.\TestAssertNotSame.ps1
	write-host "Finished testing AssertNotSame."

	write-host "Testing AssertThrows..."
	.\TestAssertThrows.ps1
	write-host "Finished testing AssertThrows."

	write-host "Testing AssertFaster..."
	.\TestAssertFaster.ps1
	write-host "Finished testing AssertFaster."
	
	write-host "Testing AssertContains..."
	.\TestAssertContains.ps1
	write-host "Finished testing AssertContains."
	
	write-host "Testing logging and tracing..."
	.\TestLogging.ps1
	write-host "Finished testing logging and tracing."
	
	write-host "Testing raising assertions..."
	.\TestRaiseAssertions.ps1
	write-host "Finished testing raising assertions."

	write-host "Testing collecting data from Excel..."
	.\TestCollectFromExcel.ps1
	write-host "Finished testing collecting data from Excel."

    write-host "Testing selecting rows from Excel..."
    .\TestSelectRow.ps1
    write-host "Finished testing selecting rows from Excel."	

    write-host "Testing start-test..."
    .\Test-RegisterActivity.ps1
    write-host "Finished testing start-test."

	# these are all example assertions that may pass or fail, depending on your system
	write-host "System assertions that may pass or fail depending on your system..."
	$wmi = Get-WMIObject Win32_OperatingSystem
	AssertEqual 0 $wmi.ServicePackMajorVersion "Service Pack Version test"
	Assert ($wmi.FreePhysicalMemory -gt 512000) "Free Physical Memory test"
	Assert ($wmi.InstallDate -gt "20051017115353.000000-420") "Installation Date test"
	RaiseAssertions
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global for now
if (!(Test-Path variable:_TESTLIB)) { .\TestLib.ps1 }

# Use any valid regular expression to limit the test condition results that get displayed
# Example: Uncomment the following line to display results from only the library tests
# $RaiseAssertionFilter = "FAILED*test"

# Use any valid regular expression to limit the test conditions that are evaluated based on their label
# Example: Uncomment the following line to evaluate only the test condition with the label TC-1
#$TestConditionFilter = "TC-1\b"

TestAll
