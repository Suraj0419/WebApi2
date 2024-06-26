param (
    [string]$appSettingsPath,
    [string]$dbServer,
    [string]$dbName,
    [string]$dbUser,
    [string]$dbPassword
)

# Read the content of appsettings.json
$jsonContent = Get-Content -Path $appSettingsPath -Raw | ConvertFrom-Json

# Add or update the connection string
if (-not $jsonContent.ConnectionStrings) {
    $jsonContent.ConnectionStrings = @{}
}
$jsonContent.ConnectionStrings.DefaultConnection = "Server=$dbServer;Database=$dbName;User Id=$dbUser;Password=$dbPassword;"

# Convert the JSON object back to a string
$jsonOutput = $jsonContent | ConvertTo-Json -Depth 32 | Out-String

# Write the updated JSON back to the file
Set-Content -Path $appSettingsPath -Value $jsonOutput
