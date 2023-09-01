<#
.Synopsis
    Uses Basic auth to generate bearer token.

.EXAMPLE 
    Get-CyberArkBasicAuth -Username "Username" -Password "Password" -Company "Company"

.NOTES
    Modified by: Derek Hartman
    Date: 8/22/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-CyberArkBasicAuth {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Username.")]
        [string[]]$Username,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Password.")]
        [string[]]$Password,

        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Company Name.")]
        [string[]]$Company
    )

    $Header = @{
        'Content-Type'  = 'application/json';
    }

    $Body = @{
        'Username'      = "$Username";
        'Password'      = "$Password";
        'ApplicationID' = "$Company";
    }

    $JsonBody =  ConvertTo-JSON $Body
	
	$Uri = "https://login.epm.cyberark.com/EPM/API/Auth/EPM/Logon"

    $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Header -Body $JsonBody
    Write-Output $Response
}