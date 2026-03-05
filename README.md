
```markdown
# 🛠️ HubSpot Under the Hood: Data Architecture Audit

This repository contains a professional toolkit to perform a real-time Technical Audit of HubSpot CRM properties. Designed for Technical Product Managers and Data Consultants.

## Workshop Goals
1. Extract "System DNA" directly from the HubSpot API.
2. Identify **Technical Debt** (Missing descriptions).
3. Detect **Data Rot** (Trash/Test properties).
4. Generate an Executive Health Check in seconds.

---

## Step 1: Secure Your Engine Key (The Access Token)

(This will be provided by Luis)
Before we start, you need a **Private App Access Token** from HubSpot:
1. Go to **Settings** > **Integrations** > **Private Apps** > **Legacy Apps**.
2. Click **Create private app**.
3. Give it a name.
4. Under **Scopes**, select: `crm.objects.contacts.read`.
5. Click **Create**, then **Show Token**, and copy the `pat-xxxx...` key.

---

## 🛰️ Step 2: Extract Raw DNA (The API Fetch)

Open your Terminal (Mac) or PowerShell (Windows) and run the command for your system to download the metadata.

### For macOS Users:
```bash
curl [https://api.hubapi.com/crm/v3/properties/contacts](https://api.hubapi.com/crm/v3/properties/contacts) \
  --header "Authorization: Bearer YOUR_TOKEN_HERE" \
  --output raw_properties.json

```

### For Windows Users (PowerShell):

```powershell
Invoke-RestMethod -Uri "[https://api.hubapi.com/crm/v3/properties/contacts](https://api.hubapi.com/crm/v3/properties/contacts)" `
  -Headers @{Authorization="Bearer YOUR_TOKEN_HERE"} | `
  ConvertTo-Json -Depth 10 | Out-File -Encoding utf8 raw_properties.json

```

---

## ⚙️ Step 3: Run the Audit Engine

Now, let's process the data. Depending on your OS, use the corresponding script provided in this repo.

### For macOS Users: download the property_audit.sh file

> **Note:** This requires `jq`. If you don't have it, the script will tell you.

```bash
chmod +x property_audit.sh
./property_audit.sh

```

### 🪟 For Windows Users: download the property_audit.ps1 file

> No installation required. Works natively in PowerShell.

```powershell
.\property_audit.ps1

```

---

## 📊 Step 4: Interpret the Health Check

Once executed, you will see an **Executive Summary** in your terminal. Here is what the status codes mean:

| Status | Meaning | Action Required |
| --- | --- | --- |
| **OK** | Fully documented and standard. | None. |
| **MISSING_DESCRIPTION** | Property exists but nobody knows why. | **Urgent:** Document or Delete. |
| **POTENTIAL_TRASH** | Name contains "test" or "asdf". | **Delete:** Cleaning required. |
| **HIDDEN_SYSTEM_FIELD** | System-level property. | **Read-only:** Do not modify. |

---

## 📂 Step 5: The Final Deliverable

The script automatically generates a file named `hubspot_technical_audit.csv`.

* **Mac:** It will open automatically in Numbers/Excel.
* **Windows:** It will trigger your default spreadsheet viewer.

Use the **Audit_Status** column to filter and prioritize your data cleanup strategy.

---

## 🔒 Security Notice

This repository includes a `.gitignore` file. Your `raw_properties.json` and `.csv` reports contain sensitive metadata and are **never** uploaded to GitHub. Keep your Private App Token secret.

---

**Presented by [Luis]** | *HubSpot Under the Hood Workshop*

```

```
