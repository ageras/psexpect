# Copyright 2009 Adam Geras
# Distributed under the BSD License (See accompanying file license.txt or copy at
# http://www.opensource.org/licenses/bsd-license.php)
set-psdebug -strict -trace 0

# Load a library containing a proxy class for the Reporting Services web service
#  (built using wsdl.exe and then compiled)
[void][Reflection.Assembly]::LoadFile("C:\wirk\ReportingService2005\ReportingService2005\bin\Debug\ReportingService2005.dll")

# Instantiate the proxy object for the web service
$repsvc = new-object ReportingService2005
$repsvc.Credentials = [System.Net.CredentialCache]::DefaultCredentials
$dsroot = "/Data Sources"
$reproot = "/AdventureWorks Sample Reports"

function Get-ItemCount
{
    param([string]$FolderPath)

    $items = $repsvc.ListChildren($FolderPath, $true)
    return $items.Count
}

function Get-DataSourceCount
{
    return (Get-ItemCount $dsroot)
}

function New-DataSource
{
    param([string]$Name)

    $dsparent = $dsroot;

    # Define the data source definition.
    $definition = new DataSourceDefinition
    $definition.CredentialRetrieval = [CredentialRetrievalEnum]::Integrated
    $definition.ConnectString = "data source=ALAPTOP\SQLEXPRESS;initial catalog=AdventureWorks"
    $definition.Enabled = $true
    $definition.EnabledSpecified = $true
    $definition.Extension = "SQL"
    $definition.ImpersonateUserSpecified = $false

    # Use the default prompt string
    $definition.Prompt = $null
    $definition.WindowsCredentials = $false

    $repsvc.CreateDataSource($Name, $dsparent, $true, $definition, $null)

}

function Test-DataSourceCount
{
    param([int32]$Expected, [string]$Label)

    $dscount = Get-DataSourceCount
    AssertEqual -Expected $Expected -Actual $dscount -Label $Label -Intention $Intention.ShouldPass
}

function Remove-DataSource
{
    param([string]$Name)
    $repsvc.DeleteItem($dsroot + "/" + $Name)
}

function Get-ReportCount
{
    return (Get-ItemCount $reproot)
}

function Test-ReportCount
{
    param([int32]$Expected, [string]$Label)

    $dscount = Get-ReportCount
    AssertEqual -Expected $Expected -Actual $dscount -Label $Label -Intention $Intention.ShouldPass
}

function New-Report
{
    param([string]$Name)

    $rdf = get-content "C:\Program Files\Microsoft SQL Server\90\Samples\Reporting Services\Report Samples\AdventureWorks Sample Reports\Company Sales.rdl"
    $encoding = new-object System.Text.ASCIIEncoding
    $definition = $encoding.GetBytes($rdf)

    $warnings = $repsvc.CreateReport($Name, $reproot, $true, $definition, $null)

}

function Remove-Report
{
    param([string]$Name)
    $repsvc.DeleteItem($reproot + "/" + $Name)
}

# To-do
function Render-Report
{
    param([string]$Name, [string]$Format)
}