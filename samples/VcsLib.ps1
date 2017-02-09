# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Load the target system assembly.
[void][Reflection.Assembly]::LoadFile((get-location).ToString() + "\PsVcs.dll")

#
# For demonstration purposes, the target 'system' is a phony little class library
# that is stateful.  In other words, you need a reference to the controller objects
# in that library to retain the results of steps within the test scenario.
# In a real system test, you would opt for stateless test steps so that you can mix and
# match them in any order without consequence.  You would not require this next object
# to be created if you had a stateless test library to work with.
#
$ConfMgr = new-object PsVcs.ConferenceManager

#
# These functions are wrapper functions that you build tests from.
# They shield the test script author from the underlying system API
# and consistently use a 'verb-noun' naming convention so that
# using them to create business-facing test scripts is easier.
#
function create-conference
{
    $conf = new-object PsVcs.Conference("PRJ1",12.0)
    [void]$ConfMgr.Add($conf)
    return $conf
}

function create-attendee
{
    $attendee = new-object PsVcs.Attendee 12
    return $attendee
}

function create-session
{
    param($Conference)

    $session = new-object PsVcs.Session("SES1",6.0)
    [void]$Conference.Add($session)
    return $session
}

function register-attendee
{
    param($element, $attendee)    
    return $element.Register($attendee)
}

function get-fees
{
    param($attendee)
    return $attendee.Fees
}

#
# These functions are "check" functions in that they perform
# some standard check of the system state
#
function test-conferencecount
{
    param([int]$Expected, [string]$Label)
    AssertEqual $Expected $ConfMgr.Conferences.Count -Label $Label    
}

function test-sessioncount
{
    param([int]$Expected, [string]$Label)
    AssertEqual $Expected $ConfMgr.WorkingConference.Sessions.Count -Label $Label
}

function test-attendeecount
{
    param([int]$Expected, [string]$Label)
    AssertEqual $Expected $ConfMgr.WorkingConference.Attendees.Count -Label $Label
}