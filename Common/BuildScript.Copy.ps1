param([string]$OutputFolder,[string] $RepoName,[string]$TargetLocation,[string] $branchName="integration")

$FolderName = [io.path]::combine([io.path]::combine($TargetLocation,$branchName),$RepoName)

if(Test-Path $FolderName)
{     
    Write-Host "Deleting old folder "+$FolderName
    Remove-Item -Recurse -Force $FolderName
}

Write-Host "Copying items from "+$OutputFolder
Write-Host "Copying items to "+$FolderName
Copy-Item ($OutputFolder+"\*") $FolderName -recurse