#requires -version 4.0
# -----------------------------------------------------------------------------
# Script: 
# Author: Eric RABOTTEAU 
# Date: 
# Keywords:
# Comments:
#
# -----------------------------------------------------------------------------

<#
[cmdletBinding()]
Param(
    [Parameter(Position=0,Mandatory=$False,ValueFromPipeline=$True)]
    [string[]]$Parameter1,
    [Parameter(Position=0,Mandatory=$False,ValueFromPipeline=$True)]
    [string[]]$Parameter2
)
#>

#uncomment needed modules
Import-Module Usefull-Tools
Import-Module Vsphere-Tools
Import-Module VMware.PowerCLI
Import-Module VMware.Hv.Helper

##logging
$ScriptName = $MyInvocation.MyCommand.Name
$MyLogfile = "c:\var\logs\$ScriptName.log"


###
# Change values to right one"
$credentialsFolder="F:\Google Drive\PowerShell\Credentials\"
$User = "rabotteau@sogeclairis.fr"



$PasswordFile = $credentialsFolder + "$user.txt"
$KeyFile = $credentialsFolder+ "$user.key"
$key = Get-Content $KeyFile
$VCCredential = New-Object -TypeName System.Management.Automation.PSCredential  -ArgumentList $User, (Get-Content $PasswordFile | ConvertTo-SecureString -Key $key)





<#
$vcenter="__VCENTER__"
try {
    Connect-VIServer $vcenter -Credential $VCcredential  -ErrorAction Stop |Out-Null
    show-MyLogger "Connected to vcenter" -Color Green
} catch {
    show-MyLogger "Error Connecting to vcenter" -Color red
    break
}
#>





###############################################################################
# End script
###############################################################################
#Disconnect-VIServer -Server $vcenter -ErrorAction SilentlyContinue |Out-Null


