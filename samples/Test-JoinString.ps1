# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

function join-string([array]$Strings, [string]$Separator="", [switch]$NewLine)
{
	if ($Strings -eq $null) { throw (new-object System.Management.Automation.ValidationMetadataException("Cannot validate argument because it is null."))}
	if (($NewLine.isPresent) -and ($Separator -ne "")) { throw (new-object System.Management.Automation.ParameterBindingException("Parameter set cannot be resolved"))}
	$joined = ""
	$sep = $Separator
	if ($NewLine.isPresent) { $sep = [System.Environment]::NewLine}
	foreach ($item in $Strings)
	{
		if ($item -eq $Strings[$Strings.Count-1])
		{
			$joined += $item
		}
		else
		{
			$joined += ($item + $sep)
		}
	}
	return $joined
}

# Tests the Join-String (above) function
function Test-Command
{
    # no separator
    $contents = "Prefix","Suffix"
    $expected = "PrefixSuffix"
    $joined = join-string -Strings $contents
    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-1" -Intent $Intention.ShouldPass

    # custom separator
    $separator = "|"
    $joined = join-string -Strings $contents -Separator $separator
    $expected = "Prefix|Suffix"
    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-2" -Intent $Intention.ShouldPass

    # newline separator
    $joined = join-string -Strings $contents -NewLine
    $expected = "Prefix" + [System.Environment]::NewLine + "Suffix"
    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-3" -Intent $Intention.ShouldPass

#    # custom and newline separators on the same command - check the result   
#    $separator = "|"
#    $joined = join-string -Strings $contents -Separator $separator -NewLine
#    $expected = "Prefix" + [System.Environment]::NewLine + "Suffix"
#    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-4" -Intent $Intention.ShouldPass

    # custom and newline separators on the same command - check the exception 
    $separator = "|"
    $blk = {$joined = join-string -Strings $contents -Separator $separator -NewLine}
    $blk | AssertThrows -ExceptionExpected "System.Management.Automation.ParameterBindingException" -MessageExpectedRegExpr "Parameter set cannot be resolved" -Label "TC-JS-5"

    # null input
    $contents = $null
    $blk = {$joined = join-string -Strings $contents}
    $blk | AssertThrows -ExceptionExpected "System.Management.Automation.ValidationMetadataException" -MessageExpectedRegExpr "Cannot validate argument because it is null." -Label "TC-JS-6"

    # elements of zero length
    $contents = "",""
    $expected = ""
    $joined = join-string -Strings $contents
    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-7" -Intent $Intention.ShouldPass

    # empty array
    $contents = [Array]::CreateInstance([string],0)
    $expected = ""
    $joined = join-string -Strings $contents
    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-8" -Intent $Intention.ShouldPass

    # larger array
    $contents = [string[]](@("a") * 10000)
    $expected = ""
    for ($i=1;$i -le 10000;$i++)
    {
        $expected += "a"
    }
    $joined = join-string -Strings $contents
    AssertEqual -Expected $expected -Actual $joined -Label "TC-JS-9" -Intent $Intention.ShouldPass
    $expected = $null
    $joined = $null
    $contents = $null
    RaiseAssertions
    
}

# run the function library that contains the PowerShell Testing Functions
# the functions are defined as global so you don't need to use dot sourcing
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# run the function defined above that demonstrates the PowerShell Testing Functions
Test-Command
