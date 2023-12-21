<#
.Synopsis
    Deletes a specific computer from CyberArk

.EXAMPLE 
    Remove-CyberArkComputerByID -ManagerURL "URL" -Token "token" -SetID "SetID" -AgentID "ID"

.NOTES
    Modified by: Derek Hartman
    Date: 9/8/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Remove-CyberArkComputerByID {
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
            HelpMessage = "Enter your Computer Agent ID.")]
        [string[]]$AgentID
    )

    $Header = @{
        'Content-Type'  = 'application/json';
        'Authorization' = "basic $Token";
    }

    $Response = Invoke-RestMethod -Uri "$($ManagerURL)/EPM/API/Sets/$($SetID)/Computers/$AgentID" -Method Delete -Headers $Header
}	