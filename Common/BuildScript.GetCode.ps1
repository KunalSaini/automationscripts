param([string]$ProjFolder = "Core-WEBS_MOServices", [string]$BranchName = "integration",[string]$SourceCodeFolder = "E:\GIT\Projects\",[string] $gitUser="mmt5235")

$ErrorActionPreference = "Stop"

Write-Host "Navigating to Code folder"
Push-Location $SourceCodeFolder

if(Test-Path $ProjFolder)
{     
    Write-Host "Deleting old folder"
    Remove-Item -Recurse -Force $ProjFolder
}
Write-Host "Cloning repository"
$cloneURL = "clone ssh://" + $gitUser + "@gerrit.mmt.com:29418/" + $ProjFolder
try {
    $BuildArgs = @{
     FilePath = "git.exe"
     ArgumentList = $cloneURL," -b",$BranchName
     Wait = $true
    }
     
   Start-Process @BuildArgs
   
 }
 catch {
  Write-Warning "Error occured: $_"
}
Pop-Location  