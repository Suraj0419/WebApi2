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

# Update the DefaultConnection property with the new connection string
$jsonContent.ConnectionStrings.DefaultConnection = $connectionString

$updatedJson = @{
    Logging = $jsonContent.Logging
    AllowedHosts = $jsonContent.AllowedHosts
    ConnectionStrings = @{
        DefaultConnection = "$connectionString"
    }
} | ConvertTo-Json -Depth 32

# Write the pretty-printed JSON to the file
$updatedJson | Set-Content -Path $appSettingsPath -Force -Encoding utf8