# ============================================================
# Script: Password Reset
# Author: Mishal Azeem
# Description: Resets a user's password and forces them to
#              change it at next login. Simulates a real
#              help desk password reset workflow.
# Usage: Run as Administrator, enter username when prompted
# ============================================================

Import-Module ActiveDirectory

# Prompt for the username
$username = Read-Host "Enter the username to reset password for"

# Check if user exists
try {
    $user = Get-ADUser -Identity $username
} catch {
    Write-Host "User '$username' not found in Active Directory." -ForegroundColor Red
    exit
}

# Set the new temporary password
$tempPassword = ConvertTo-SecureString "TempPass123!" -AsPlainText -Force

# Reset the password
try {
    Set-ADAccountPassword -Identity $username -Reset -NewPassword $tempPassword
    
    # Force user to change password at next logon
    Set-ADUser -Identity $username -ChangePasswordAtLogon $true

    Write-Host "`nPassword reset successfully for: $($user.Name)" -ForegroundColor Green
    Write-Host "Temporary password: TempPass123!" -ForegroundColor Yellow
    Write-Host "User must change password at next login." -ForegroundColor Yellow

} catch {
    Write-Host "Failed to reset password: $($_.Exception.Message)" -ForegroundColor Red
}
