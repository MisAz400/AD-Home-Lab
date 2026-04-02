# ============================================================
# Script: Inactive Account Detection
# Author: Mishal Azeem
# Description: Finds user accounts that have been inactive
#              for 30+ days and exports a report. This is a
#              key security practice to reduce attack surface
#              from stale accounts.
# Usage: Run as Administrator. Report saved to C:\Scripts\
# ============================================================

Import-Module ActiveDirectory

# Set inactivity threshold in days
$inactiveDays = 30
$cutoffDate = (Get-Date).AddDays(-$inactiveDays)
$reportPath = "C:\Scripts\Inactive_Users_Report.csv"

Write-Host "Searching for accounts inactive for $inactiveDays+ days..." -ForegroundColor Cyan

# Find inactive accounts
$inactiveUsers = Search-ADAccount -AccountInactive -TimeSpan ([TimeSpan]::FromDays($inactiveDays)) -UsersOnly |
    Get-ADUser -Properties LastLogonDate, Department, Manager, Enabled |
    Where-Object { $_.Enabled -eq $true } |
    Select-Object Name, SamAccountName, LastLogonDate, Department, Enabled

# Display results
if ($inactiveUsers.Count -eq 0) {
    Write-Host "No inactive accounts found." -ForegroundColor Green
} else {
    Write-Host "`nFound $($inactiveUsers.Count) inactive account(s):`n" -ForegroundColor Yellow
    $inactiveUsers | Format-Table Name, SamAccountName, LastLogonDate, Department -AutoSize

    # Export to CSV report
    $inactiveUsers | Export-Csv -Path $reportPath -NoTypeInformation
    Write-Host "Report saved to: $reportPath" -ForegroundColor Green
    Write-Host "`nReview these accounts with your manager before disabling." -ForegroundColor Yellow
}
