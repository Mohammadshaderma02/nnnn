# PowerShell Script: Migrate eKYC Methods from GSM to FTTH
# This script copies missing eKYC methods from GSM_NationalityList.dart to FTTH NationalityList.dart

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "eKYC Migration: GSM to FTTH" -ForegroundColor Cyan  
Write-Host "========================================" -ForegroundColor Cyan

$gsmFile = "D:\mobile-dev\sales-app-ekyc\lib\Views\HomeScreens\Subdealer\Menu\PostPaid\GSM\GSM_NationalityList.dart"
$ftthFile = "D:\mobile-dev\sales-app-ekyc\lib\Views\HomeScreens\Subdealer\Menu\PostPaid\FTTH\NationalityList.dart"
$backupDir = "D:\mobile-dev\sales-app-ekyc\backup_ftth_ekyc_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Check if files exist
if (-not (Test-Path $gsmFile)) {
    Write-Host "ERROR: GSM file not found: $gsmFile" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $ftthFile)) {
    Write-Host "ERROR: FTTH file not found: $ftthFile" -ForegroundColor Red
    exit 1
}

# Create backup
Write-Host "`nCreating backup..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path $backupDir | Out-Null
Copy-Item $ftthFile "$backupDir\NationalityList.dart.backup"
Write-Host "Backup created at: $backupDir" -ForegroundColor Green

# Read both files
Write-Host "`nReading source and target files..." -ForegroundColor Yellow
$gsmContent = Get-Content $gsmFile -Raw
$ftthContent = Get-Content $ftthFile -Raw

# List of methods to check and copy if missing
$methodsToCheck = @(
    "_initializeCamera",
    "_initializeCameraMRZ", 
    "_initializeCameraTemporary",
    "_initializeCameraForeign",
    "_stopCameraAndCleanup",
    "_stopCameraAndCleanupMRZ",
    "_stopCameraAndCleanupTemporary",
    "_stopCameraAndCleanupForeign",
    "_processFrameMRZ",
    "_processFrameTemporary",
    "_processFrameForeign",
    "generateEkycToken",
    "startSession",
    "sanad_API",
    "sanadAuthorization_API",
    "documentProcessingID_API",
    "documentProcessingPassport_API",
    "documentProcessingPassportTemp_API",
    "documentProcessingPassportForeign_API",
    "uploadFrontID_API",
    "uploadBackID_API",
    "uploadPassportFile_API",
    "uploadPassportTempFile_API",
    "uploadPassportForeignFile_API",
    "_validatePassportMRZ",
    "_validatePassportTemporary",
    "_validatePassportForeign",
    "_buildOverlayFrame",
    "_buildOverlayFrameMRZ",
    "_buildOverlayFrameTemporary",
    "_buildOverlayFrameForeign",
    "_buildStepText",
    "_buildStepTextMRZ",
    "_buildStepTextTemporary",
    "_buildStepTextForeign",
    "_buildTipText",
    "_buildTipTextMRZ",
    "_buildTipTextTemporary",
    "_buildTipTextForeign",
    "_buildQualityIndicator",
    "_buildSideIndicator",
    "_buildRestartButton",
    "_startFrameProcessing",
    "_startFrameProcessingMRZ",
    "_startFrameProcessingTemporary",
    "_startFrameProcessingForeign",
    "_startStepTimeout",
    "_resetScannerState",
    "_restartScanning",
    "_restartCameraAndTimers",
    "_calculateBlurScore",
    "_isImageQualityAcceptable",
    "_getQualityMessage",
    "_showSuccessfulValidationMRZ",
    "_showFailedValidationMRZ",
    "_showSuccessfulValidationTemporary",
    "_showFailedValidationTemporary",
    "_showSuccessfulValidationForeign",
    "_showFailedValidationForeign",
    "_extractAndStoreMRZ",
    "createHttpClient"
)

Write-Host "`nChecking for missing methods..." -ForegroundColor Yellow
$missingMethods = @()

foreach ($method in $methodsToCheck) {
    # Check if method exists in FTTH file
    if ($ftthContent -notmatch "(?m)^\s*(Future<[^>]+>|void|Widget|bool|String|double|int)?\s+$method\s*\(") {
        $missingMethods += $method
        Write-Host "  - Missing: $method" -ForegroundColor Red
    } else {
        Write-Host "  - Found: $method" -ForegroundColor Green
    }
}

if ($missingMethods.Count -eq 0) {
    Write-Host "`nAll methods are present in FTTH file!" -ForegroundColor Green
    Write-Host "No migration needed." -ForegroundColor Green
    exit 0
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Found $($missingMethods.Count) missing methods" -ForegroundColor Yellow
Write-Host "========================================" -ForegroundColor Cyan

Write-Host "`nNOTE: This script detected missing methods but cannot automatically copy them" -ForegroundColor Yellow
Write-Host "due to the complexity of the code structure." -ForegroundColor Yellow
Write-Host "`nPlease manually review and copy the following methods from GSM to FTTH:" -ForegroundColor Yellow

foreach ($method in $missingMethods) {
    Write-Host "  - $method" -ForegroundColor Cyan
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "Migration Analysis Complete" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "`nBackup location: $backupDir" -ForegroundColor Green
Write-Host "`nNext steps:" -ForegroundColor Yellow
Write-Host "1. Manually copy missing methods from GSM file to FTTH file"  -ForegroundColor White
Write-Host "2. Update navigation paths to use FTTH customer info screens" -ForegroundColor White
Write-Host "3. Test compilation with: flutter analyze" -ForegroundColor White
Write-Host "4. Run the app and test the eKYC flow" -ForegroundColor White
