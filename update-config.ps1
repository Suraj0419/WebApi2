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

$jsonContent.ConnectionStrings.DefaultConnection = $connectionString

# Convert the updated JSON object back to a JSON string
$updatedJson = $jsonContent | ConvertTo-Json -Depth 32 -Compress

# Pretty-print the JSON to ensure no escape sequences
$prettyJson = $updatedJson -replace '\\u0027', "'"

# Write the pretty-printed JSON to the file
$prettyJson | Out-File -FilePath $appSettingsPath -Force -Encoding utf8