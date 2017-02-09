# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Load the target system assembly.
[void][Reflection.Assembly]::LoadFile((get-location).ToString() + "\PsAccountManager.dll")

#
# These functions are wrapper functions that you build tests from.
# They shield the test script author from the underlying system API
# and consistently use a 'verb-noun' naming convention so that
# using them to create business-facing test scripts is easier.
#
function create-account
{
    param($AccountType, $InitialBalance)
    $acc = new-object PsAccountManager.Account($AccountType, $InitialBalance)
    return $acc
}

function transfer-money
{
    param($From, $To, $Amount)
    $From.TransferTo($To, $Amount)
}

function set-accountbalance
{
    param($Account, $Amount)

    $Account.Balance = $Amount
}

#
# These functions are "check" functions in that they perform
# some standard check of the system state
#
function test-accountbalance
{

    param($Account, $Expected, [string]$Label)
    AssertEqual $Expected $Account.Balance -Label $Label
}

