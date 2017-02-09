# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Load the function library that contains the PowerShell Testing Functions
# the functions are defined as global 
#if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
#if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

..\src\TestLib.ps1

# Load the library containing functions that bridge the test script
# to the system under test
. .\VcsLib.ps1

given "A new conference" {
    set-variable -name conference -value (create-conference) -scope script
}

then "The attendee and session count should be zero" {
    test-attendeecount -Expected 0 -Label "Attendees.Count.Before"
    test-sessioncount -Expected 0 -Label "Sessions.Count.Before"
}

given "A new session for the conference" {
    set-variable -name session -value (create-session $conference) -scope script
}

then "The session count should be 1" {
    test-sessioncount -Expected 1 -Label "Sessions.Count.After"
}

given "A new attendee"  { 
    set-variable -name attendee -value (create-attendee) -scope script 
}

when "I register the attendee for conference and for the session" { 
    $fees = register-attendee $conference $attendee 
    $fees = register-attendee $session $attendee
}

then "the conference should indicate an attendee count of 1" { 
    test-attendeecount -Expected 1 -Label "Attendees.Count.After" 
}

then "the attendee fees should be the sum of the conference and session fees" {
    $totalfees = get-fees $attendee
    AssertEqual ($conference.Fees + $session.Fees) $totalfees -Label "Attendee.Fees"
}

RaiseAssertions