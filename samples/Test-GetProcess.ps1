# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Sample tests for the get-process cmdlet
function TestGetProcess
{
	$procs = get-process
    AssertNotNull $procs "GP-1a"
    $allProcsCount = $procs.length
    Assert ($allProcsCount -gt 0) "GP-1b"
    AssertInstanceOf System.Array $procs "GP-1c"

    $procs = get-process explorer
    AssertNotNull $procs "GP-2a"
    AssertInstanceOf System.Diagnostics.Process $procs "GP-2b"

    $procs = get-process svc*
    AssertNotNull $procs "GP-3a"
    Assert ($allProcsCount -gt $procs.length) "GP-3b"
    AssertInstanceOf System.Array $procs "GP-3c"

    $procs = get-process explorer
    AssertNotNull $procs "GP-4a"
    $explorerId = $procs.Id
    $procs = get-process -id $procs.Id
    AssertNotNull $procs "GP-4b"
    AssertInstanceOf System.Diagnostics.Process $procs "GP-4c"
    AssertEqual explorer $procs.Name "GP-4d"

    RaiseAssertions

}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
TestGetProcess
