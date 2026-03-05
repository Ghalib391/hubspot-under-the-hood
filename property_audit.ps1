$input_file = "raw_properties.json"
$output_file = "hubspot_technical_audit.csv"

Write-Host "Starting Technical Property Audit..."

$data = Get-Content $input_file | ConvertFrom-Json
$data.results | Select-Object label, name, type, fieldType, groupName, hidden, hubspotDefined, formField, description, @{Name="Audit_Status"; Expression={
    if([string]::IsNullOrEmpty($_.description)){"MISSING_DESCRIPTION"}
    elseif($_.name -match "test"){"POTENTIAL_TRASH"}
    elseif($_.hidden -eq $true){"HIDDEN_SYSTEM_FIELD"}
    else{"OK"}
}} | Export-Csv -Path $output_file -NoTypeInformation -Encoding utf8

Write-Host "Audit Complete!"
Write-Host "--------------------------------------"
Write-Host "EXECUTIVE SUMMARY:"
Import-Csv $output_file | Group-Object Audit_Status -NoElement
Write-Host "--------------------------------------"

# Open in Windows
Invoke-Item $output_file
