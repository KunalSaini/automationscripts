param([string]$RepoName = "Core-WEBS_MOServices", 
[string]$BranchName = "integration",
[string]$DeploymentFolder,
[string]$iisAppPoolDotNetVersion = "v4.0")

Import-Module WebAdministration

$iisAppPoolName = $BranchName + "." + $RepoName
$iisAppName = $iisAppPoolName 

#navigate to the app pools root
Push-Location IIS:\AppPools\

#check if the app pool exists, else create it
if (!(Test-Path $iisAppPoolName -pathType container))
{
    Write-Host "creating app pool - " $iisAppPoolName
    $appPool = New-Item $iisAppPoolName
    $appPool | Set-ItemProperty -Name "managedRuntimeVersion" -Value $iisAppPoolDotNetVersion
}else
{
    Write-Host "App pool already exist, recycling - " $iisAppPoolName 
    Restart-WebAppPool $iisAppPoolName
}

#navigate to the sites root
Push-Location IIS:\Sites\'Default Web Site'\

#check if the site exists
if (Test-Path $iisAppName -pathType container)
{
    $fullPath = "IIS:\Sites\'Default Web Site'\"+$iisAppName
    Write-Host "Application already exist - $iisAppName, setting app pool - $iisAppPoolName "
    #$iisApp = Get-WebApplication $fullPath
    #$iisApp.ApplicationPool = $iisAppPoolName
    #$iisApp | Set-Item
}else
{
    Write-Host "Creating application in IIS - "$iisAppName 
    $iisApp = New-Item $iisAppName -type Application -physicalPath $DeploymentFolder -ApplicationPool $iisAppPoolName
}

Pop-Location
Pop-Location