<#
.SYNOPSIS
    Builds and packages the Flutter Windows desktop application using Velopack.

.DESCRIPTION
    This script automates:
    1. Building the Flutter release binary for Windows (x64)
    2. Downloading previous releases from GitHub (to generate delta updates)
    3. Packaging the release using the Velopack (vpk) CLI
    4. Optionally publishing the release assets to GitHub Releases

.PARAMETER Version
    The semantic version string for this release (e.g. 1.0.0). Defaults to pubspec.yaml version.

.PARAMETER PackId
    The Velopack package identifier. Defaults to 'StudentManagementSystem'.

.PARAMETER RepoUrl
    The GitHub repository URL (e.g. https://github.com/owner/student_management_system).

.PARAMETER Token
    GitHub Personal Access Token with repo/release write permissions.

.PARAMETER Publish
    Switch to upload the packaged release to GitHub Releases.

.PARAMETER Channel
    Release channel (e.g. win, stable). Defaults to 'win'.

.EXAMPLE
    .\scripts\package-release.ps1 -Version "1.0.1" -RepoUrl "https://github.com/mohamedfelfl/student_management_system"
#>

[CmdletBinding()]
param(
    [string]$Version,
    [string]$PackId = "StudentManagementSystem",
    [string]$RepoUrl = "https://github.com/mohamedfelfl/student_management_system",
    [string]$Token,
    [switch]$Publish,
    [string]$Channel = "win"
)

$ErrorActionPreference = 'Stop'

# Ensure .NET 9 roll-forward is enabled for vpk
$env:DOTNET_ROLL_FORWARD = "LatestMajor"

# Fallback to environment variable or git credential helper for GitHub token if not passed directly
if (-not $Token) {
    if ($env:GITHUB_TOKEN) { $Token = $env:GITHUB_TOKEN }
    elseif ($env:GH_TOKEN) { $Token = $env:GH_TOKEN }
    else {
        $gcmPaths = @(
            "C:\Program Files\Git\mingw64\bin\git-credential-manager.exe",
            "git-credential-manager"
        )
        foreach ($gcm in $gcmPaths) {
            try {
                $process = New-Object System.Diagnostics.Process
                $process.StartInfo.FileName = $gcm
                $process.StartInfo.Arguments = "get"
                $process.StartInfo.UseShellExecute = $false
                $process.StartInfo.RedirectStandardInput = $true
                $process.StartInfo.RedirectStandardOutput = $true
                $process.StartInfo.CreateNoWindow = $true
                [void]$process.Start()
                $process.StandardInput.WriteLine("protocol=https")
                $process.StandardInput.WriteLine("host=github.com")
                $process.StandardInput.WriteLine("")
                $process.StandardInput.Close()
                $output = $process.StandardOutput.ReadToEnd()
                $process.WaitForExit()
                if ($output) {
                    foreach ($line in ($output -split "`r?`n")) {
                        if ($line.Trim().StartsWith("password=")) {
                            $Token = $line.Trim().Substring(9).Trim()
                            break
                        }
                    }
                }
                if ($Token) { break }
            } catch {}
        }
    }
}

# Ensure user-level .NET SDK and vpk tools are on PATH
$dotnetDir = "$env:USERPROFILE\.dotnet"
$toolsDir = "$env:USERPROFILE\.dotnet\tools"
if (Test-Path $dotnetDir) {
    $env:DOTNET_ROOT = $dotnetDir
    $env:PATH = "$dotnetDir;$toolsDir;$env:PATH"
}

Write-Host "=== Student Management System - Velopack Packaging ===" -ForegroundColor Cyan

# 1. Resolve version from pubspec.yaml if not provided
if (-not $Version) {
    if (Test-Path "pubspec.yaml") {
        $pubspec = Get-Content "pubspec.yaml" -Raw
        if ($pubspec -match 'version:\s*([0-9]+\.[0-9]+\.[0-9]+)') {
            $Version = $matches[1]
            Write-Host "Resolved version from pubspec.yaml: $Version" -ForegroundColor Green
        }
    }
}

if (-not $Version) {
    Write-Error "Version must be specified or defined in pubspec.yaml (e.g. 1.0.0)"
    exit 1
}

# 2. Verify prerequisites (vpk tool)
$vpkInstalled = Get-Command "vpk" -ErrorAction SilentlyContinue
if (-not $vpkInstalled) {
    Write-Host "Velopack CLI (vpk) is not installed. Installing via dotnet tool..." -ForegroundColor Yellow
    dotnet tool update -g vpk
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Failed to install vpk tool. Ensure .NET 6.0+ SDK is installed."
        exit 1
    }
}

# 3. Create Releases output directory
$releasesDir = Join-Path $PSScriptRoot "..\Releases"
if (-not (Test-Path $releasesDir)) {
    New-Item -ItemType Directory -Path $releasesDir -Force | Out-Null
}

# 4. Download previous releases for delta generation if RepoUrl provided
if ($RepoUrl) {
    Write-Host "`nDownloading previous releases from GitHub for delta generation..." -ForegroundColor Cyan
    try {
        vpk download github --repoUrl $RepoUrl --outputDir $releasesDir
    }
    catch {
        Write-Warning "Could not download previous releases from GitHub. Proceeding with full package build."
    }
}

# 5. Build Flutter Windows release
Write-Host "`nBuilding Flutter Windows release..." -ForegroundColor Cyan
flutter build windows --release
if ($LASTEXITCODE -ne 0) {
    Write-Error "Flutter build failed."
    exit 1
}

$buildRunnerDir = "build\windows\x64\runner\Release"
if (-not (Test-Path $buildRunnerDir)) {
    # Check alternate build path (e.g. build\windows\runner\Release)
    if (Test-Path "build\windows\runner\Release") {
        $buildRunnerDir = "build\windows\runner\Release"
    }
    else {
        Write-Error "Could not locate Flutter build output in $buildRunnerDir"
        exit 1
    }
}

# 6. Pack using Velopack (vpk)
Write-Host "`nPackaging release with Velopack ($Version)..." -ForegroundColor Cyan
$packArgs = @(
    "pack",
    "--packId", $PackId,
    "--packVersion", $Version,
    "--packDir", $buildRunnerDir,
    "--mainExe", "student_management_system.exe",
    "--packTitle", "Student Management System",
    "--channel", $Channel,
    "-o", $releasesDir
)

& vpk @packArgs
if ($LASTEXITCODE -ne 0) {
    Write-Error "Velopack packaging failed."
    exit 1
}

Write-Host "`nSuccessfully packaged to: $releasesDir" -ForegroundColor Green
Get-ChildItem $releasesDir | Select-Object Name, Length, LastWriteTime | Format-Table -AutoSize

# 7. Optionally publish to GitHub
if ($Publish) {
    if (-not $RepoUrl -or -not $Token) {
        Write-Error "Both -RepoUrl and -Token are required to publish releases to GitHub."
        exit 1
    }

    Write-Host "`nUploading release to GitHub ($RepoUrl)..." -ForegroundColor Cyan
    $uploadArgs = @(
        "upload", "github",
        "--repoUrl", $RepoUrl,
        "--publish",
        "--tag", "v$Version",
        "--releaseName", "Release v$Version",
        "--token", $Token,
        "--outputDir", $releasesDir
    )
    & vpk @uploadArgs
    if ($LASTEXITCODE -eq 0) {
        Write-Host "Successfully published release v$Version to GitHub!" -ForegroundColor Green
    }
    else {
        Write-Error "Failed to upload release to GitHub."
        exit 1
    }
}

Write-Host "`nDone!" -ForegroundColor Green
