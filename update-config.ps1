param (
  [string]$appSettingsPath,
  [string]$dbServer,
  [string]$dbName,
  [string]$dbUser,
  [string]$dbPassword
)

# Read the content of appsettings.json
$jsonContent = Get-Content -Path $appSettingsPath -Raw | ConvertFrom-Json

# Handle potential null value and empty 'ConnectionStrings'
if ($jsonContent) {
  if (-not $jsonContent.ContainsKey('ConnectionStrings')) {
    $jsonContent | Add-Member -MemberType NoteProperty -Name 'ConnectionStrings' -Value @{}
  }

  # Create 'DefaultConnection' property
  $jsonContent.ConnectionStrings | Add-Member -MemberType NoteProperty -Name 'DefaultConnection' -Value @{}

  # Set the connection string for 'DefaultConnection'
  $jsonContent.ConnectionStrings.DefaultConnection = "Server=$dbServer;Database=$dbName;User Id=$dbUser;Password=$dbPassword;"

  # Convert the JSON object back to a string (same as before)
  $jsonOutput = $jsonContent | ConvertTo-Json -Depth 32 | Out-String

  # Write the updated JSON back to the file (same as before)
  Set-Content -Path $appSettingsPath -Value $jsonOutput
} else {
  Write-Error "Error: Unable to read appsettings.json file."
}
