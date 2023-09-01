<#
.Synopsis
    Retrieve list of sets to be used with other API commands.

.EXAMPLE 
    Get-CyberArkSetList -ManagerURL "URL" -Token "token"

.NOTES
    Modified by: Derek Hartman
    Date: 8/23/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-CyberArkSetList {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Manager URL.")]
        [string[]]$ManagerURL,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Token.")]
        [string[]]$Token
    )

    $Header = @{
        'Content-Type'  = 'application/json';
        'Authorization' = "basic $Token";
    }
	
	$Uri = "$($ManagerURL)/EPM/API/Sets"

    $Response = Invoke-RestMethod -Uri $Uri -Method Get -Headers $Header
    Write-Output $Response
}