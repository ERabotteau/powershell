$psISE.Options.Zoom = 100


#region InsertRegionBlock - Alt+R 
Function InsertRegionBlock {
    $Editor  = $psISE.CurrentFile.Editor
  Try {
   [void][Microsoft.VisualBasic.Interaction]
      } Catch  {
  Add-Type  –assemblyName Microsoft.VisualBasic
  } 
  $Name = [Microsoft.VisualBasic.Interaction]::InputBox("Enter  Region Information", "Region Information")
  $CaretLine  = $Editor.CaretLine
  $SelectedText  = $Editor.SelectedText
  $NewText  = "#region  {0}`n{1}`n#endregion {0}" -f $Name,$SelectedText
  $Editor.InsertText($NewText)
  $Editor.SetCaretPosition($CaretLine, 1)
}
#endregion InsertRegionBlock - Alt+R

#requires -version 2.0
$psmenu=$psise.CurrentPowerShellTab.AddOnsMenu.Submenus
$psISE.CurrentPowerShellTab.AddOnsMenu.Submenus.Clear()

$psmenu.Add("Load ConfigMGR Module", {Connect-ConfigMgr},"ALT+F1") | out-Null
$psmenu.Add("Load VMware PowerCLI Module",{Load-PowerCLI},$Null) | out-Null

#Main Sub Menus
$ToolsMenu = $psmenu.Add("Tools",$null,$null)
$ProfileMenu = $psmenu.Add("Profiles",$null,$null)

#short access
$psmenu.Add(“Save All Files”,{Save-AllISEFiles},"CTRL+Shift+S") | out-Null
$psmenu.Add("Insert New Function",{ISE-New-Function},$null) | out-Null
$psmenu.Add("Insert Powercli Module",{ISE-Insert-PowercliLoad},$null) | out-Null
$psmenu.Add("Insert SCCM ConfigMGR Load",{ISE-Insert-ConfigMGR},$null) | out-Null




# acces direct sous tools
$ToolsMenu.submenus.Add("Sign Script",{Write-Signature},$null) | Out-Null


#create submenus for tools
$Book = $ToolsMenu.Submenus.add("Bookmarks",$Null,$Null)
$convert = $ToolsMenu.Submenus.Add("Convert",$Null,$null)
$dates = $ToolsMenu.submenus.Add("Dates and Times",$Null,$Null)
$files = $ToolsMenu.Submenus.Add("Files",$Null,$null)
$work = $ToolsMenu.submenus.Add("Work",$Null,$null)
$scripting = $ToolsMenu.Submenus.Add("Scripting",$Null,$null)


# Profiles commands
$ProfileMenu.Submenus.add("Edit your ISE profile",{Edit-ISEProfile},$Null) | out-Null
$ProfileMenu.Submenus.add("Edit your Global profile",{Edit-GlobalProfile},$Null) | out-Null
$ProfileMenu.Submenus.add("Edit ISE Template",{Edit-ISETemplate},$Null) | out-Null



# Tools -> Bookmarks
$book.Submenus.Add("Add ISE Bookmark",{Add-ISEBookmark},"Ctrl+Shift+N") | Out-Null
$book.Submenus.Add("Clear ISE Bookmarks",{del $MyBookmarks},$null) | Out-Null
$book.Submenus.Add("Get ISE Bookmark",{Get-ISEBookmark},"Ctrl+Shift+G") | Out-Null
$book.Submenus.Add("Open ISE Bookmark",{Open-ISEBookmark},"Ctrl+Shift+O") | Out-Null
$book.Submenus.Add("Remove ISE Bookmark",{Remove-ISEBookmark},"Ctrl+Shift+K") | Out-Null
$book.Submenus.Add("Update ISE Bookmark",{Update-ISEBookmark},"Ctrl+Shift+X") | Out-Null


# tools -> Work
$work.submenus.Add("Add current file to work",{Add-CurrentProject -List $currentProjectList},"CTRL+Alt+A") | Out-Null
$work.submenus.Add("Edit current work file",{Edit-CurrentProject -List $currentProjectList},"CTRL+Alt+E") | Out-Null
$work.submenus.Add("Open current work files",{Import-CurrentProject -List $currentProjectList},"CTRL+Alt+I") | Out-Null

#tools -> Dates
$dates.submenus.Add("Insert Datetime",{$psise.CurrentFile.Editor.InsertText(("{0} {1}" -f (get-date),(get-wmiobject win32_timezone -property StandardName).standardName))},"ALT+F5") | out-Null
$dates.submenus.Add("Insert Short Date",{$psISE.currentfile.editor.inserttext((Get-Date).ToShortDateString())},"ALT+F6") | out-Null
$dates.submenus.Add("Insert Short Time",{$psISE.currentfile.editor.inserttext((Get-Date).ToShortTimeString())},"ALT+F7") | out-Null
$dates.submenus.Add("Insert Short Date Time",{$psISE.currentfile.editor.inserttext((Get-Date -Format g))},"ALT+F8") | out-Null
$dates.submenus.Add("Insert Long Date",{$psISE.currentfile.editor.inserttext((Get-Date -displayhint Date))},"ALT+F9") | out-Null
$dates.submenus.Add("Insert UTC Date",{$psISE.currentfile.editor.inserttext((Get-Date -format u))},"ALT+F10") | out-Null
$dates.submenus.Add("Insert GMT Date",{$psISE.currentfile.editor.inserttext((Get-Date -format r))},"ALT+F11") | out-Null


# add Tools -> Files
$files.Submenus.Add("Close All Files",{CloseAllFiles},"Ctrl+Alt+F4") | out-Null
$files.Submenus.Add("Close All Files Except Active",{CloseAllFilesButCurrent},"Ctrl+Shift+F4") | out-Null
$files.submenus.Add("Open Current Script Folder",{Invoke-Item (split-path $psise.CurrentFile.fullpath)},"ALT+O") | Out-Null
$files.Submenus.Add("Open Selected File",{Open-SelectedISE},"Ctrl+Alt+F") | Out-Null
$files.Submenus.Add("Reload Selected File",{Reload-ISEFile},"Ctrl+Alt+R") | Out-Null
$files.submenus.add("-",$null,$null) | Out-Null
$files.Submenus.Add("New File",{New-FileHere},"Ctrl+Alt+N") | Out-Null
    
#add Tools -> Convert
$convert.Submenus.Add("Block Comment Selected", {ConvertTo-MultiLineComment}, "Ctrl+SHIFT+B") | out-Null
$convert.Submenus.Add("Block Uncomment Selected", {ConvertFrom-MultiLineComment}, "Ctrl+Alt+B") | out-Null
$convert.Submenus.Add("Comment Selected", {ConvertTo-Comment}, "Ctrl+SHIFT+C") | out-Null
$convert.Submenus.Add("Uncomment Selected", {ConvertFrom-Comment}, "Ctrl+Alt+C") | out-Null
    



#add Tool -> Scripting
$scripting.SubMenus.Add("Insert Region Block",{InsertRegionBlock},$null) | out-Null
$scripting.Submenus.Add("Insert Comment Help", {ISE-New-CommentBlock}, $null) | out-Null

# add Module browser
Add-Type -Path "C:\Program Files\WindowsPowerShell\Modules\ISEModuleBrowserAddon\1.0.1.0\ISEModuleBrowserAddon.dll"
$moduleBrowser = $psISE.CurrentPowerShellTab.VerticalAddOnTools.Add('Module Browser', [ModuleBrowser.Views.MainView], $true) 
$psISE.CurrentPowerShellTab.VisibleVerticalAddOnTools.SelectedAddOnTool = $moduleBrowser


# Management Files
$MyBookmarks = Join-Path -path $era.WinScripts -ChildPath "myISEBookmarks.csv"
$CurrentProjectList = Join-Path -Path $era.WinScripts -ChildPath "currentWork.txt"
$iseresources=Join-Path -Path $era.WinScripts -ChildPath "resources"

Write-Host "Loading ISE PowerShell functions from:" -ForegroundColor Green
Write-Host "$($era.FunctionsISE)" -ForegroundColor Yellow
Get-ChildItem "$($era.FunctionsISE)\*.ps1" | %{.$_}
Write-Host ''