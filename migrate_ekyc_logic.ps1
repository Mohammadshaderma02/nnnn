# eKYC Migration Script
# This script copies the Sanad and eKYC logic from GSM to BroadBand and FTTH modules

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "eKYC & Sanad Migration Script" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

$baseDir = "D:\mobile-dev\sales-app-ekyc\lib\Views\HomeScreens\Subdealer\Menu\PostPaid"
$backupDir = "D:\mobile-dev\sales-app-ekyc\backup_before_ekyc_migration_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

# Create backup directory
Write-Host "Creating backup directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

# Backup BroadBand files
Write-Host "Backing up BroadBand files..." -ForegroundColor Yellow
Copy-Item "$baseDir\BroadBand\BroadBand_SelectNationality.dart" "$backupDir\BroadBand_SelectNationality.dart.bak" -Force
Copy-Item "$baseDir\BroadBand\BroadBand_Jordainian.dart" "$backupDir\BroadBand_Jordainian.dart.bak" -Force -ErrorAction SilentlyContinue
Copy-Item "$baseDir\BroadBand\BroadBand_NonJordanina.dart" "$backupDir\BroadBand_NonJordanina.dart.bak" -Force -ErrorAction SilentlyContinue

# Backup FTTH files
Write-Host "Backing up FTTH files..." -ForegroundColor Yellow
Copy-Item "$baseDir\FTTH\NationalityList.dart" "$backupDir\FTTH_NationalityList.dart.bak" -Force
Copy-Item "$baseDir\FTTH\JordainianCustomerInformation.dart" "$backupDir\FTTH_JordainianCustomerInformation.dart.bak" -Force -ErrorAction SilentlyContinue
Copy-Item "$baseDir\FTTH\NonJordainianCustomerInformation.dart" "$backupDir\FTTH_NonJordainianCustomerInformation.dart.bak" -Force -ErrorAction SilentlyContinue

Write-Host "Backup completed at: $backupDir" -ForegroundColor Green
Write-Host ""

# Copy GSM_NationalityList to BroadBand
Write-Host "Copying GSM logic to BroadBand_SelectNationality..." -ForegroundColor Yellow
$gsmContent = Get-Content "$baseDir\GSM\GSM_NationalityList.dart" -Raw

# Replace class names and marketType for BroadBand
$broadbandContent = $gsmContent `
    -replace 'class NationalityList', 'class BroadBandSelectNationality' `
    -replace '_NationalityListState', '_BroadBandSelectNationalityState' `
    -replace 'GSM_JordainianCustomerInformation', 'BroadBand_Jordainian' `
    -replace 'GSM_NonJordainianCustomerInformation', 'BroadBand_NonJordanina' `
    -replace 'JordainianCustomerInformation', 'BroadBand_Jordainian' `
    -replace 'NonJordainianCustomerInformation', 'BroadBand_NonJordanina' `
    -replace 'marketType\s*==\s*"GSM"', 'marketType == "BROADBAND"'

$broadbandContent | Set-Content "$baseDir\BroadBand\BroadBand_SelectNationality.dart" -Encoding UTF8

Write-Host "BroadBand_SelectNationality.dart updated successfully!" -ForegroundColor Green
Write-Host ""

# Copy GSM_NationalityList to FTTH
Write-Host "Copying GSM logic to FTTH NationalityList..." -ForegroundColor Yellow
$ftthContent = $gsmContent `
    -replace 'class NationalityList', 'class FTTHNationalityList' `
    -replace '_NationalityListState', '_FTTHNationalityListState' `
    -replace 'GSM_JordainianCustomerInformation', 'FTTHJordainianCustomerInformation' `
    -replace 'GSM_NonJordainianCustomerInformation', 'FTTHNonJordainianCustomerInformation' `
    -replace 'JordainianCustomerInformation', 'FTTHJordainianCustomerInformation' `
    -replace 'NonJordainianCustomerInformation', 'FTTHNonJordainianCustomerInformation' `
    -replace 'marketType\s*==\s*"GSM"', 'marketType == "FTTH"'

$ftthContent | Set-Content "$baseDir\FTTH\NationalityList.dart" -Encoding UTF8

Write-Host "FTTH NationalityList.dart updated successfully!" -ForegroundColor Green
Write-Host ""

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Migration Complete!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Summary:" -ForegroundColor Yellow
Write-Host "✓ Backup created at: $backupDir" -ForegroundColor Green
Write-Host "✓ BroadBand_SelectNationality.dart updated with eKYC logic" -ForegroundColor Green
Write-Host "✓ FTTH NationalityList.dart updated with eKYC logic" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Review the updated files" -ForegroundColor White
Write-Host "2. Test the BroadBand module" -ForegroundColor White
Write-Host "3. Test the FTTH module" -ForegroundColor White
Write-Host "4. If issues occur, restore from: $backupDir" -ForegroundColor White
Write-Host ""
Write-Host "To restore backups if needed:" -ForegroundColor Cyan
Write-Host 'Copy-Item from backup directory if needed' -ForegroundColor Gray
Write-Host ""
