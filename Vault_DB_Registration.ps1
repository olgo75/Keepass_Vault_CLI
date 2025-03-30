#requires -modules PoshKeePass, SecretManagement.KeePass, Microsoft.PowerShell.SecretManagement

# Déclaration des variables
$KeePassDatabaseFilePath = "<chemin vers la base KeePass>"
$KeePassMasterKey = ConvertTo-SecureString -String "<mot de passe de la base KeePass>" -AsPlainText -Force
$KeePassDatabaseProfileName = "<nom de la base KeePass>"
$VaultName = "<nom du vault>"

# Enregistrement de la base KeePass - module PoshKeePass
New-KeePassDatabaseConfiguration -DatabaseProfileName $KeePassDatabaseProfileName -DatabasePath $KeePassDatabaseFilePath -UseMasterKey

# Enregistrement de la base KeePass - module SecretManagement.KeePass
Register-SecretVault -Name $VaultName -Verbose -ModuleName 'SecretManagement.KeePass' -DefaultVault -VaultParameters @{
    DatabaseProfileName = $KeePassDatabaseProfileName
    MasterKey = $KeePassMasterKey
}

# Lister les vaults
Write-Host "`nVaults PoshKeePass : " -ForegroundColor Cyan
Get-KeePassDatabaseConfiguration | Format-Table -AutoSize
Write-Host "`nVaults SecretManagement.KeePass : " -ForegroundColor Cyan
Get-SecretVault | Format-Table -AutoSize