# Find out if the current user identity is elevated (has admin rights)
$identity = [Security.Principal.WindowsIdentity]::GetCurrent()
$principal = New-Object Security.Principal.WindowsPrincipal $identity
$isAdmin = $principal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
Remove-Variable identity
Remove-Variable principal
# If so and the current host is a command line, then change to red color 
# as warning to user that they are operating in an elevated context
if (($host.Name -match "ConsoleHost") -and ($isAdmin))
{
     $host.UI.RawUI.BackgroundColor = "DarkRed"
     $host.PrivateData.ErrorBackgroundColor = "White"
     $host.PrivateData.ErrorForegroundColor = "DarkRed"
     Clear-Host
}



#run powershell as admin
function admin
{
    if ($args.Count -gt 0)
    {   
       $argList = "& '" + $args + "'"
       Start-Process "$psHome\powershell.exe" -Verb runAs -ArgumentList $argList
    }
    else
    {
       Start-Process "$psHome\powershell.exe" -Verb runAs
    }
}
Set-Alias -Name su -Value admin
Set-Alias -Name sudo -Value admin


#define some ISE specific variables
#Root Folder
$global:era = New-Object psobject
$userprofile = $env:USERPROFILE
$era | Add-Member NoteProperty "MyDocs" ([Environment]::GetFolderPath('MyDocuments'))
$era | Add-Member NoteProperty "Scripts" "$GDriveRoot\PowerShell"
$era | Add-Member NoteProperty "WinScripts" (join-Path -path  $era.MyDocs -ChildPath "WindowsPowerShell")

$era | Add-Member NoteProperty "Functions" "$GDriveRoot\WindowsPowerShell\Functions"
$era | Add-Member NoteProperty "Modules" "$GDriveRoot\WindowsPowerShell\Modules"
$era | Add-Member NoteProperty "FunctionsCommon" "$GDriveRoot\WindowsPowerShell\Functions\Common"
$era | Add-Member NoteProperty "FunctionsISE" "$GDriveRoot\WindowsPowerShell\Functions\ISE"



Write-Host "Loading Common PowerShell functions from:" -ForegroundColor Green
Write-Host "$($era.FunctionsCommon)" -ForegroundColor Yellow
Get-ChildItem "$($era.FunctionsCommon)\*.ps1" | %{.$_}
Write-Host ''




# aller dans Mes Documents
function Goto-MesDocuments {
    Set-Location $era.MyDocs
}
Set-Alias cdm Goto-MesDocuments

function Goto-PowerShellFolder {
    set-location $era.Scripts
}
set-alias cdp goto-PowerShellFolder
set-alias Show Get-ChildItem

set-alias nsl do-nslookup

Function llm #lock Local machine
{

 $signature = @"  
    [DllImport("user32.dll", SetLastError = true)]  
    public static extern bool LockWorkStation();  
"@  
    $LockWorkStation = Add-Type -memberDefinition $signature -name "Win32LockWorkStation" -namespace Win32Functions -passthru  

    $LockWorkStation::LockWorkStation()|Out-Null
}


function Is-Elevated {
    $prp = new-object System.Security.Principal.WindowsPrincipal([System.Security.Principal.WindowsIdentity]::GetCurrent())
    $prp.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator)
}

$env:psmodulepath+=";$($era.modules)"

New-PSDrive -Name Scripts -PSProvider FileSystem -Root $era.Scripts -Description "Scripts powershell" | Out-Null
function Scripts: { Set-Location Scripts: }
New-PSDrive -Name Modules -PSProvider FileSystem -Root $era.Modules -Description "Modules powershell" | Out-Null
function Modules: { Set-Location Modules: }

Import-Module Usefull-Tools
Import-Module Vsphere-Tools

cd (Resolve-Path $era.scripts)