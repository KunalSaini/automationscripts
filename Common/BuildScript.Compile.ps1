param([string]$RepoName = "Core-WEBS_MOServices",[string]$SolutionFile = "MMT_WEBS_MOServices.sln",[string]$SourceCodeFolder = "E:\GIT\Projects\",[string]$Configuration ="Release",[string]$OutputDirectory="")

# GET MSBuild Path
# valid versions are [2.0, 3.5, 4.0]
$dotNetVersion = "4.0"
$regKey = "HKLM:\software\Microsoft\MSBuild\ToolsVersions\$dotNetVersion"
$regProperty = "MSBuildToolsPath"
$progFolder = [io.path]::combine($SourceCodeFolder, $RepoName)
$SlnFilePath = [io.path]::combine($progFolder,$SolutionFile)
Write-Host "Starting Build Process"
if($OutputDirectory -eq "")
{
    $OutputDirectory = [io.path]::combine($progFolder,"Output")
}
$BuildLog = [io.path]::combine($progFolder,"buildlog.txt")
$msbuildExe = join-path -path (Get-ItemProperty $regKey).$regProperty -childpath "msbuild.exe"

$nugetPath = [io.path]::combine($PSScriptRoot,"nuget.exe")
Invoke-Expression ($nugetPath +" restore "+ $SlnFilePath) | Out-Null

    $BuildArgs = @{
     FilePath = $msbuildExe
     ArgumentList = $SlnFilePath, "/t:clean,rebuild", ("/p:Configuration=" + $Configuration),("/p:OutDir="+$OutputDirectory), ("/flp:logfile=" + $BuildLog ),"/toolsversion:4.0"
     Wait = $true
     }
     
    # Start the build
    Start-Process @BuildArgs
    
    $buildResult =  Select-String -Pattern "Build succeeded." -Path $BuildLog -Quiet
    If ($buildResult -ne $true)
    {
        Write-Host "Build Failed with status " $LastExitCode
        notepad.exe $BuildLog
    }Else
    {
        Write-Host "Build Succesfull, output at " $OutputDirectory
        #explorer $OutputDirectory
    }