# incremental_git_commit_push_files_only.ps1

$BatchSizeMB = 250
$CommitPrefix = "Add sample project content batch"
$BranchName = "main"

$ErrorActionPreference = "Stop"

function Get-FileSizeBytes($Path) {
    if (Test-Path $Path -PathType Leaf) {
        return (Get-Item $Path).Length
    }
    return 0
}

function Format-Bytes($Bytes) {
    if ($Bytes -ge 1GB) { return "{0:N2} GB" -f ($Bytes / 1GB) }
    if ($Bytes -ge 1MB) { return "{0:N2} MB" -f ($Bytes / 1MB) }
    if ($Bytes -ge 1KB) { return "{0:N2} KB" -f ($Bytes / 1KB) }
    return "$Bytes B"
}

Write-Host "Checking git status..." -ForegroundColor Cyan
git status --short

# This expands untracked directories into individual files and respects .gitignore.
$files = @()

# Modified / deleted / tracked changes
$trackedChanges = git diff --name-only
$files += $trackedChanges

# Staged changes, in case any already exist
$stagedChanges = git diff --cached --name-only
$files += $stagedChanges

# Untracked files, excluding ignored files
$untrackedFiles = git ls-files --others --exclude-standard
$files += $untrackedFiles

$files = $files | Sort-Object -Unique

if (-not $files -or $files.Count -eq 0) {
    Write-Host "No changes to commit." -ForegroundColor Green
    exit 0
}

Write-Host ""
Write-Host "Found $($files.Count) individual changed/untracked files." -ForegroundColor Cyan
Write-Host "Batch target: $(Format-Bytes ($BatchSizeMB * 1MB))"
Write-Host ""

$batch = @()
$batchBytes = 0
$batchNumber = 1
$totalCommittedFiles = 0

foreach ($file in $files) {
    $fileSize = Get-FileSizeBytes $file

    if ($batch.Count -gt 0 -and (($batchBytes + $fileSize) -gt ($BatchSizeMB * 1MB))) {
        Write-Host "------------------------------------------------------------"
        Write-Host "Batch $batchNumber"
        Write-Host "Files: $($batch.Count)"
        Write-Host "Size:  $(Format-Bytes $batchBytes)"
        Write-Host "------------------------------------------------------------"

        foreach ($batchFile in $batch) {
            git add -- "$batchFile"
        }

        git commit -m "$CommitPrefix $batchNumber"
        git push origin $BranchName

        $totalCommittedFiles += $batch.Count
        $batchNumber++
        $batch = @()
        $batchBytes = 0
    }

    $batch += $file
    $batchBytes += $fileSize
}

if ($batch.Count -gt 0) {
    Write-Host "------------------------------------------------------------"
    Write-Host "Batch $batchNumber"
    Write-Host "Files: $($batch.Count)"
    Write-Host "Size:  $(Format-Bytes $batchBytes)"
    Write-Host "------------------------------------------------------------"

    foreach ($batchFile in $batch) {
        git add -- "$batchFile"
    }

    git commit -m "$CommitPrefix $batchNumber"
    git push origin $BranchName

    $totalCommittedFiles += $batch.Count
}

Write-Host ""
Write-Host "Done." -ForegroundColor Green
Write-Host "Committed and pushed $totalCommittedFiles files across $batchNumber batch(es)."