<#
.Synopsis
    Retrieve list of sets to be used with other API commands.

.EXAMPLE 
    Get-CyberArkComputer -ManagerURL "URL" -Token "token" -SetID "SetID" -ComputerName "ComputerName"

.NOTES
    Modified by: Derek Hartman
    Date: 8/23/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-CyberArkComputer {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Manager URL.")]
        [string[]]$ManagerURL,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Token.")]
        [string[]]$Token,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Set ID.")]
        [string[]]$SetID,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Computer Name.")]
        [string[]]$ComputerName
    )

    $Header = @{
        'Content-Type'  = 'application/json';
        'Authorization' = "basic $Token";
    }
	
	$Uri = "$($ManagerURL)/EPM/API/Sets/$($SetID)/Computers?`$filter=ComputerName eq '$($ComputerName)'"

    $Response = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header
    Write-Output $Response
}