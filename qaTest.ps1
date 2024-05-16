param(
    [string]$sourceFolder,
    [string]$replicaFolder,
    [string]$logFilePath
)

function LogMessage {
    param(
        [string]$message
    )
    $logMessage = "$message"
    Write-Output $logMessage
    Add-content -Path $logFilePath -Value $logMessage
}

if (-not (Test-Path $sourceFolder -PathType Container)) {
    Write-Host "The folder '$sourceFolder' is missing"
    exit 1
}

if (-not (Test-Path $replicaFolder -PathType Container)) {
    Write-Host "The folder '$replicaFolder'is missing"
    exit 1
}

$sourceFiles = Get-ChildItem $sourceFolder -Recurse
$replicaFiles = Get-ChildItem $replicaFolder -Recurse

foreach ($replicaFile in $replicaFiles) {
    $sourceFilePath = $replicaFile.FullName -replace [regex]::Escape($replicaFolder), $sourceFolder
    if (-not (Test-Path $sourceFilePath)) {
        Remove-Item $replicaFile.FullName -Force
        LogMessage "Removed from $($replicaFile.FullName)"
    }
}

foreach ($sourceFile in $sourceFiles) {
    $replicaFilePath = $sourceFile.FullName -replace [regex]::Escape($sourceFolder), $replicaFolder
    if (-not (Test-Path $replicaFilePath)) {
        Copy-Item $sourceFile.FullName -Destination $replicaFilePath
        LogMessage "Copied from $($sourceFile.FullName)"
    }
}

Write-Host "Completed"