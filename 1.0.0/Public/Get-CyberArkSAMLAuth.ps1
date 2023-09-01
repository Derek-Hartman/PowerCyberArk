<#
.Synopsis
    Uses SAML auth to generate bearer token.

.EXAMPLE 
    Get-CyberArkSAMLAuth -LoginURL "loginURL"

.NOTES
    Modified by: Derek Hartman
    Date: 8/25/2023

#>
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Function Get-CyberArkSAMLAuth {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $True,
            ValueFromPipeline = $True,
            HelpMessage = "Enter your Username.")]
        [string]$LoginURL
    )
    Function New-SAMLInteractive{
        [CmdletBinding()]
        param(
            [Parameter(Mandatory = $True,
                ValueFromPipeline = $True,
                HelpMessage = "Enter your Username.")]
            [string]$LoginIDPURL
        )
 
        Begin{
 
            $RegEx = '(?i)name="SAMLResponse"(?: type="hidden")? value=\"(.*?)\"(?:.*)?\/>'
 
            Add-Type -AssemblyName System.Windows.Forms 
            Add-Type -AssemblyName System.Web
 
        }
 
        Process{
 
            # create window for embedded browser
            $form = New-Object Windows.Forms.Form
            $form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen;
            $form.Width = 640
            $form.Height = 700
            $form.showIcon = $false
            $form.TopMost = $true
    
            $web = New-Object Windows.Forms.WebBrowser
            $web.Size = $form.ClientSize
            $web.Anchor = "Left,Top,Right,Bottom"
            $web.ScriptErrorsSuppressed = $true
 
            $form.Controls.Add($web)
 
            $web.Navigate($LoginIDPURL)
        
            $web.add_Navigating({
    
                if ($web.DocumentText -match "SAMLResponse"){
 
                    $_.cancel = $true
 
                    if ($web.DocumentText -match $RegEx){
            
                        $form.Close()
                        $Script:SAMLResponse = $(($Matches[1] -replace '&#x2b;', '+') -replace '&#x3d;', '=')
                    
 
                    }
 
                }
 
            })
    
            # show browser window, waits for window to close
            if([system.windows.forms.application]::run($form) -ne "OK") {
            
                if ($null -ne $Script:SAMLResponse){
 
                    Write-Output $Script:SAMLResponse
                    $form.Close()
                    Remove-Variable -Name SAMLResponse -Scope Script -ErrorAction SilentlyContinue
 
                }
                Else{
            
                    throw "SAMLResponse not matched"
            
                }
    
            }
        }
 
        End{
        
            $form.Dispose()
        
        }
 
    }
    #Logon
    $SAMlResponse = New-SAMLInteractive -LoginIDPURL $LoginURL

    $Header = @{
        'Content-Type'  = 'application/x-www-form-urlencoded';
    }

    $Body = @{ 
        concurrentSession='true' 
        apiUse='true' 
        SAMLResponse=$SAMlResponse 
    }
	
	$Uri = "https://login.epm.cyberark.com/SAML/Logon"

    $Response = Invoke-RestMethod -Uri $Uri -Method Post -Headers $Header -Body $Body -ContentType 'application/x-www-form-urlencoded'
    Write-Output $Response    
}