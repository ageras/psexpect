# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

function TestAllSamples
{

	# results of assertions are not displayed until raised using the RaiseAssertions function
	RaiseAssertions
	write-host "Testing Account actions..."
	.\Test-AccountActions.ps1
	write-host "Finished testing Account actions."
	
	RaiseAssertions
	write-host "Testing GetProcess..."
	.\Test-GetProcess.ps1
	write-host "Finished testing GetProcess."

	RaiseAssertions
	write-host "Testing GetProcess from Excel..."
	.\Test-GetProcessExcel.ps1
	write-host "Finished testing GetProcess from Excel."
		
	RaiseAssertions
	write-host "Testing GetWeather..."
	.\Test-GetWeather.ps1
	write-host "Finished testing GetWeather."
	
	RaiseAssertions
	write-host "Testing GetWeatherPerf..."
	.\Test-GetWeatherPerf.ps1
	write-host "Finished testing GetWeatherPerf."

	RaiseAssertions
	write-host "Testing JoinString..."
	.\Test-JoinString.ps1
	write-host "Finished testing JoinString."

	RaiseAssertions
	write-host "Testing Resource..."	
	.\Test-Resource.ps1
	write-host "Finished testing Resource."

#
# Only un-comment these if you have Reporting Services (SSRS) installed
#
#	RaiseAssertions
#	write-host "Testing RsConfig..."
#	.\Test-RsConfig.ps1
#	write-host "Finished testing RsConfig."

	RaiseAssertions
	write-host "Testing VCS..."
	.\Test-Vcs.ps1
	write-host "Finished testing VCS."

	RaiseAssertions
	write-host "Testing VCS via GWT..."
	.\Test-VcsBehave.ps1
	write-host "Finished testing VCS via GWT."

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

TestAllSamples
