param(
    [string]$Version,
    [string]$Token,
    [string]$RepoUrl = "https://github.com/mohamedfelfl/elite_series"
)

$ErrorActionPreference = 'Stop'
$env:DOTNET_ROLL_FORWARD = "LatestMajor"
$dotnetDir = "$env:USERPROFILE\.dotnet"
$toolsDir = "$env:USERPROFILE\.dotnet\tools"
$env:PATH = "$dotnetDir;$toolsDir;$env:PATH"

# Resolve version from pubspec.yaml if not provided
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
    Write-Error "Version must be specified or defined in pubspec.yaml (e.g. 1.0.3)"
    exit 1
}

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

if (-not $Token) {
    Write-Error "GitHub token is required to upload the release. Set GITHUB_TOKEN or pass -Token."
    exit 1
}

$releasesDir = Join-Path $PSScriptRoot "..\Releases"

Write-Host "Uploading release v$Version to GitHub ($RepoUrl)..." -ForegroundColor Cyan

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
} else {
    Write-Error "Failed to upload release to GitHub."
}
