#!/usr/bin/env pwsh

param(
    [Parameter(Mandatory=$true)]
    [string]$InputFile
)

$outputFile = $InputFile -replace '\.yaml$', '.enc.yaml'

if (-not (Test-Path $InputFile)) {
    Write-Error "Input file '$InputFile' not found"
    exit 1
}

Write-Host "Encrypting $InputFile -> $outputFile"

sops encrypt --gcp-kms projects/kbs610/locations/global/keyRings/sops/cryptoKeys/sops-key $InputFile > $outputFile

if ($LASTEXITCODE -eq 0) {
    Write-Host "Successfully encrypted to $outputFile"
} else {
    Write-Error "Encryption failed"
    exit $LASTEXITCODE
}
