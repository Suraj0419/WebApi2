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



# Convert the updated object back to JSON and write to the file
$jsonContent | ConvertTo-Json -Depth 32 | Out-File -FilePath $appSettingsPath -Force -Encoding utf8

# Re-read the JSON content to pretty print it
$prettyJsonContent = Get-Content -Path $appSettingsPath -Raw | ConvertFrom-Json | ConvertTo-Json -Depth 32
$prettyJsonContent | Set-Content -Path $appSettingsPath -Force
