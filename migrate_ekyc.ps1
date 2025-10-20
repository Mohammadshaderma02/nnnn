# eKYC Migration Script
Write-Host "========================================"
Write-Host "eKYC & Sanad Migration Script"
Write-Host "========================================"
Write-Host ""

$baseDir = "D:\mobile-dev\sales-app-ekyc\lib\Views\HomeScreens\Subdealer\Menu\PostPaid"
$backupDir = "D:\mobile-dev\sales-app-ekyc\backup_ekyc_$(Get-Date -Format 'yyyyMMdd_HHmmss')"

Write-Host "Creating backup directory..."
New-Item -ItemType Directory -Path $backupDir -Force | Out-Null

Write-Host "Backing up BroadBand files..."
Copy-Item "$baseDir\BroadBand\BroadBand_SelectNationality.dart" "$backupDir\BroadBand_SelectNationality.dart.bak" -Force

Write-Host "Backing up FTTH files..."
Copy-Item "$baseDir\FTTH\NationalityList.dart" "$backupDir\FTTH_NationalityList.dart.bak" -Force

Write-Host "Backup completed!"
Write-Host ""

Write-Host "Copying GSM logic to BroadBand..."
$gsmContent = Get-Content "$baseDir\GSM\GSM_NationalityList.dart" -Raw

$broadbandContent = $gsmContent -replace 'class NationalityList', 'class BroadBandSelectNationality'
$broadbandContent = $broadbandContent -replace '_NationalityListState', '_BroadBandSelectNationalityState'
$broadbandContent = $broadbandContent -replace 'GSM_JordainianCustomerInformation', 'BroadBand_Jordainian'
$broadbandContent = $broadbandContent -replace 'GSM_NonJordainianCustomerInformation', 'BroadBand_NonJordanina'
$broadbandContent = $broadbandContent -replace 'JordainianCustomerInformation', 'BroadBand_Jordainian'
$broadbandContent = $broadbandContent -replace 'NonJordainianCustomerInformation', 'BroadBand_NonJordanina'

$broadbandContent | Set-Content "$baseDir\BroadBand\BroadBand_SelectNationality.dart" -Encoding UTF8

Write-Host "BroadBand updated successfully!"
Write-Host ""

Write-Host "Copying GSM logic to FTTH..."
$ftthContent = $gsmContent -replace 'class NationalityList', 'class FTTHNationalityList'
$ftthContent = $ftthContent -replace '_NationalityListState', '_FTTHNationalityListState'
$ftthContent = $ftthContent -replace 'GSM_JordainianCustomerInformation', 'FTTHJordainianCustomerInformation'
$ftthContent = $ftthContent -replace 'GSM_NonJordainianCustomerInformation', 'FTTHNonJordainianCustomerInformation'
$ftthContent = $ftthContent -replace 'JordainianCustomerInformation', 'FTTHJordainianCustomerInformation'
$ftthContent = $ftthContent -replace 'NonJordainianCustomerInformation', 'FTTHNonJordainianCustomerInformation'

$ftthContent | Set-Content "$baseDir\FTTH\NationalityList.dart" -Encoding UTF8

Write-Host "FTTH updated successfully!"
Write-Host ""
Write-Host "========================================"
Write-Host "Migration Complete!"
Write-Host "========================================"
Write-Host ""
Write-Host "Backup location: $backupDir"
Write-Host ""
