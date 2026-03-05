#!/bin/bash

# --- Interactive Dependency Check ---

# 1. JQcheck
if ! command -v jq &> /dev/null; then
    echo "⚠️  JQ is not installed (required for Mac users)."
    read -p "❓ Do you want to install Homebrew and JQ now? (y/n): " confirm
    if [[ $confirm == [yY] || $confirm == [yY][eE][sS] ]]; then
        
        # has brew
        if ! command -v brew &> /dev/null; then
            echo "🚀 Installing Homebrew... (this may take a few minutes)"
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
            # load brew
            eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
        fi
        
        echo "📦 Installing JQ..."
        brew install jq
    else
        echo "Cannot proceed without JQ. Please install it manually and try again."
        exit 1
    fi
fi

# --- Rest of the Script ---

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
