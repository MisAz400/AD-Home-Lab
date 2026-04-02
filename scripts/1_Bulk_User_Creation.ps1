# ============================================================
# Script: Bulk User Creation from CSV
# Author: Mishal Azeem
# Description: Creates multiple AD user accounts from a CSV file
#              and assigns them to the correct OU and group.
# Usage: Update the CSV path and run as Administrator
# ============================================================

# Import the Active Directory module
Import-Module ActiveDirectory

# Path to your CSV file - update this to match where your CSV is saved
$csvPath = "C:\Scripts\new_users.csv"

# Import users from CSV
$users = Import-Csv -Path $csvPath

foreach ($user in $users) {

    # Build the full name and user principal name
    $fullName = "$($user.FirstName) $($user.LastName)"
    $upn = "$($user.Username)@mishalab.local"

    # Convert password to secure string
    $securePassword = ConvertTo-SecureString $user.Password -AsPlainText -Force

    # Set the OU path based on department
    switch ($user.Department) {
        "IT"          { $ouPath = "OU=IT,DC=mishalab,DC=local" }
        "HR"          { $ouPath = "OU=HR,DC=mishalab,DC=local" }
        "Finance"     { $ouPath = "OU=Finance,DC=mishalab,DC=local" }
        "Engineering" { $ouPath = "OU=Engineering,DC=mishalab,DC=local" }
        default       { $ouPath = "CN=Users,DC=mishalab,DC=local" }
    }

    # Create the user account
    try {
        New-ADUser `
            -Name $fullName `
            -GivenName $user.FirstName `
            -Surname $user.LastName `
            -SamAccountName $user.Username `
            -UserPrincipalName $upn `
            -Path $ouPath `
            -AccountPassword $securePassword `
            -Department $user.Department `
            -Title $user.JobTitle `
            -Enabled $true

        Write-Host "Created user: $fullName in $($user.Department) OU" -ForegroundColor Green

        # Add user to their department security group
        Add-ADGroupMember -Identity "$($user.Department)-*" -Members $user.Username

    } catch {
        Write-Host "Failed to create user: $fullName - $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nBulk user creation complete." -ForegroundColor Cyan
