param (
    [string]$appSettingsPath,
    [string]$dbServer,
    [string]$dbName,
    [string]$dbUser,
    [string]$dbPassword
)

# Read JSON content from the appsettings.json file
$jsonContent = Get-Content -Path $appSettingsPath -Raw | ConvertFrom-Json

# Ensure ConnectionStrings property exists and is an object
if (-not $jsonContent.ConnectionStrings) {
    $jsonContent | Add-Member -MemberType NoteProperty -Name 'ConnectionStrings' -Value @{}
}

$connectionString = "Server=$dbServer; Database=$dbName; User Id=$dbUser; Password=$dbPassword;"

# Construct the new ConnectionStrings section
$newConnectionStrings = @"
"ConnectionStrings": {
    "DefaultConnection": "$connectionString"
}
"@

# Replace the existing ConnectionStrings section with the new one
$updatedJsonContent = $jsonContent -replace '"ConnectionStrings": {[^}]*}', $newConnectionStrings

# Write the updated JSON content back to the file
$updatedJsonContent | Set-Content -Path $appSettingsPath -Force -Encoding utf8