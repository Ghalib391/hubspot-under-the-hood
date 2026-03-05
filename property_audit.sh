#!/bin/bash

INPUT="raw_properties.json"
OUTPUT="hubspot_technical_audit.csv"

echo "Starting Technical Property Audit..."

# 1. Header
echo "Label,Internal_Name,Type,Field_Type,Group,Hidden,HubSpot_Defined,Form_Field,Description,Audit_Status" > "$OUTPUT"

# 2. Processing (Single-line logic for safety)
cat "$INPUT" | jq -r '.results // [] | .[]? | select(objects) | [ .label, .name, .type, .fieldType, .groupName, .hidden, .hubspotDefined, .formField, .description, (if (.description == null or .description == "") then "MISSING_DESCRIPTION" elif (.name | test("test"; "i")) then "POTENTIAL_TRASH" elif (.hidden == true) then "HIDDEN_SYSTEM_FIELD" else "OK" end) ] | @csv' >> "$OUTPUT"

echo "Audit Complete!"
echo "--------------------------------------"
echo "EXECUTIVE SUMMARY (Health Check):"
awk -F',' '{print $NF}' "$OUTPUT" | tr -d '"' | grep -v "Audit_Status" | sort | uniq -c
echo "--------------------------------------"

# 3. Open the result (Mac)
open "$OUTPUT"
