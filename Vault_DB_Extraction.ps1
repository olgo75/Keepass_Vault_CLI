#requires -modules PoshKeePass, SecretManagement.KeePass, Microsoft.PowerShell.SecretManagement

# Déclaration des variables
$KeePassMasterKey = ConvertTo-SecureString -String "<mot de passe de la base KeePass>" -AsPlainText -Force
$KeePassDatabaseProfileName = "<nom de la base KeePass>"
$VaultName = "<nom du vault>"

# Ouverture du vault
Unlock-SecretVault -Name $KeePassDatabaseProfileName -Password $KeePassMasterKey

# Listage des secrets
$GroupPath = "Database/General"
$entries = Get-KeePassEntry -DatabaseProfileName $KeePassDatabaseProfileName -MasterKey $KeePassMasterKey -KeePassEntryGroupPath $GroupPath

foreach ($entry in $entries) {
    
    $entryValues = Get-Secret -Name $($entry.Title) -Vault $VaultName
    
    $entryDetails = [PSCustomObject][ordered]@{
        Nom = $($entry.Title)
        Password = $($entryValues.GetNetworkCredential().Password)
        Description = $($entry.Notes)
    }

    $entryDetails
}