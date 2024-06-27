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

# Update the DefaultConnection property with the new connection string
$jsonContent.ConnectionStrings.DefaultConnection = "Server=$dbServer; Database=$dbName; User Id=$dbUser; Password=$dbPassword;"

$decodedContent = $jsonContent -replace '\\u0027', "'"

# Convert the updated object back to JSON and write to the file
$decodedContent | ConvertTo-Json -Depth 32 | Set-Content -Path $appSettingsPath -Force
