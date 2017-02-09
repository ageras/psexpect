# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Load the function library that contains the PowerShell Testing Functions
# the functions are defined as global 
if (!(Test-Path variable:_XLLIB)) { ..\src\DataLib.ps1 }
if (!(Test-Path variable:_TESTLIB)) { ..\src\TestLib.ps1 }

# Load the library containing functions that bridge the test script
# to the system under test
. ..\samples\VcsLib.ps1

###
### This is the start of the test scenario.  For each step in the
### scenario, notice that the step follows a verb-noun naming
### convention.  The noun part should come from the business domain
### and the verb part should either be standard PoSh verbs or come from the
### business domain.
###

# check the current status matches expectations
test-conferencecount -Expected 0 -Label "Conferences.Count.Before"

# setup the test
$attendee = create-attendee
$conference = create-conference
$session = create-session $conference

# execute the target test scenario - in this case the target is the calculation
# of the fees that a particular attendee owes based on their registration
$fees = register-attendee $conference $attendee
$fees = register-attendee $session $attendee

# check - in this case the test script author has decided to check the counts
# of all the domain objects - using wrapper functions that were provided by
# the test developer
test-conferencecount -Expected 1 -Label "Conferences.Count.After"
test-sessioncount -Expected 1 -Label "Sessions.Count.After"
test-attendeecount -Expected 1 -Label "Attendees.Count.After"

# check the total fees for the attendee - should be the sum of the
# conference registration fee and the session registration fee
$totalfees = get-fees $attendee
AssertEqual ($conference.Fees + $session.Fees) $totalfees -Label "Attendee.Fees"

# tear down - in this case we don't have any tear down steps only because
# we're working with a toy system as our test target

# show the results of the checks
RaiseAssertions

###
### End of the test scenario
###