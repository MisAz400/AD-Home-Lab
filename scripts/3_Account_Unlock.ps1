# ============================================================
# Script: Account Unlock
# Author: Mishal Azeem
# Description: Checks if a user account is locked and unlocks
#              it. Simulates a real help desk unlock workflow
#              triggered by account lockout policy.
# Usage: Run as Administrator, enter username when prompted
# ============================================================

Import-Module ActiveDirectory

# Prompt for the username
$username = Read-Host "Enter the username to check and unlock"

# Check if user exists
try {
    $user = Get-ADUser -Identity $username -Properties LockedOut, LastLogonDate, BadLogonCount
} catch {
    Write-Host "User '$username' not found in Active Directory." -ForegroundColor Red
    exit
}

# Display account status
Write-Host "`nAccount Status for: $($user.Name)" -ForegroundColor Cyan
Write-Host "Locked Out:       $($user.LockedOut)"
Write-Host "Bad Logon Count:  $($user.BadLogonCount)"
Write-Host "Last Logon:       $($user.LastLogonDate)"

# Check if locked and unlock
if ($user.LockedOut) {
    try {
        Unlock-ADAccount -Identity $username
        Write-Host "`nAccount successfully unlocked for: $($user.Name)" -ForegroundColor Green
    } catch {
        Write-Host "Failed to unlock account: $($_.Exception.Message)" -ForegroundColor Red
    }
} else {
    Write-Host "`nAccount is not locked. No action needed." -ForegroundColor Yellow
}
