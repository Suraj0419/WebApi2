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



$updatedJson = $jsonContent | ConvertTo-Json -Depth 32 -Compress | 
    ForEach-Object { $_ -replace '\\u0027', "'" }

# Pretty-print the JSON
$prettyJson = $updatedJson | ConvertFrom-Json | ConvertTo-Json -Depth 32

# Write the pretty-printed JSON to the file
$prettyJson | Set-Content -Path $appSettingsPath -Force