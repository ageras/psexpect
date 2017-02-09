# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Load the function library that contains the PowerShell Testing Functions
# the functions are defined as global 
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

. .\AccountLib.ps1

# Story: Transfer to cash account from savings account
# As a savings account holder
# I want to transfer money from my savings account
# So that I can get cash easily from an ATM

# Scenario 1: Savings account is in credit
given "My savings account balance is 100 and my cash account balance is 10" {
    set-variable -name SvAccount -value (create-account "Savings" 100) -scope script
    set-variable -name csAccount -value (create-account "Cash" 10) -scope script
}

when "I transfer 20 to my cash account from savings" {
    transfer-money -From $SvAccount -To $CsAccount -Amount 20
}

then "my cash account balance should be 30 and my savings account balance should be 80" {
    test-accountbalance -Account $SvAccount -Expected 80 -Label "Savings.Balance.After"
    test-accountbalance -Account $CsAccount -Expected 30 -Label "Cash.Balance.After"
}

given "My savings account balance is 400 and my cash account balance is 100" {
    set-accountbalance -Account $SvAccount -Amount 400
    set-accountbalance -Account $CsAccount -Amount 100
}

when "I transfer 100 to my cash account" {
    transfer-money -From $SvAccount -To $CsAccount -Amount 100
}

then "My cash account balance should be 200 and my savings account balance should be 300" {
    test-accountbalance -Account $SvAccount -Expected 300 -Label "Savings.Balance.After"
    test-accountbalance -Account $CsAccount -Expected 200 -Label "Cash.Balance.After"
}

RaiseAssertions
