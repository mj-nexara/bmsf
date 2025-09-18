# Setup-BMSF-Docs.ps1
# Purpose: Create inheritable documentation structure for B.M. Sabab Foundation under /docs
# Location: C:\MJ-Ahmad\bmsf\docs\bmsf-docs\

$docsPath = "C:\MJ-Ahmad\bmsf\bmsf-docs\docs"
$logPath = "$docsPath\docs_setup_log.yaml"

function Confirm-And-CreateFolder {
    param (
        [string]$path,
        [string]$label
    )
    Write-Host "Create folder: $label at $path ?" -ForegroundColor Cyan
    $confirm = Read-Host "Type Y to confirm"
    if ($confirm -eq "Y") {
        New-Item -Path $path -ItemType Directory -Force | Out-Null
        Add-Content -Path $logPath -Value "- created: '$label' at '$path'"
    } else {
        Add-Content -Path $logPath -Value "- skipped: '$label'"
    }
}

function CreateMarkdown {
    param (
        [string]$folder,
        [string]$filename,
        [string]$title
    )
    $filePath = Join-Path $folder "$filename.md"
    $content = "# $title`nThis section is under construction."
    Set-Content -Path $filePath -Value $content
    Add-Content -Path $logPath -Value "- markdown created: '$filename.md' in '$folder'"
}

# Create root docs folder
Confirm-And-CreateFolder -path $docsPath -label "Root Docs Folder"

# Define documentation sections
$sections = @(
    "00_About",
    "01_Governance",
    "02_Legal_Compliance/National_Laws",
    "02_Legal_Compliance/International_Laws",
    "03_Finance/Audit_Reports",
    "04_HR_and_Volunteers/Staff_Contracts",
    "04_HR_and_Volunteers/Training_Modules",
    "05_Programs_and_Operations/National_Programs/Legal_Aid",
    "05_Programs_and_Operations/National_Programs/Education",
    "05_Programs_and_Operations/International_Programs/Refugee_Support",
    "05_Programs_and_Operations/International_Programs/Global_Advocacy",
    "06_Monitoring_and_Evaluation/Field_Reports",
    "07_IT_and_Digital/YAML_Logs",
    "08_Archives_and_Legacy/Ritualized_Scripts/PowerShell",
    "08_Archives_and_Legacy/Ritualized_Scripts/Excel_Templates",
    "08_Archives_and_Legacy/Multilingual_Documentation"
)

# Create folders and sample markdown files
foreach ($section in $sections) {
    $fullPath = Join-Path $docsPath $section
    Confirm-And-CreateFolder -path $fullPath -label $section
    CreateMarkdown -folder $fullPath -filename "README" -title $section
}

# Create root index.md
CreateMarkdown -folder $docsPath -filename "index" -title "B.M. Sabab Foundation Documentation"

# Create mkdocs.yml
$mkdocsContent = @"
site_name: B.M. Sabab Foundation
site_description: Inheritable, audit-ready documentation for ethical governance
site_author: MJ Ahmad
repo_url: https://github.com/mj-nexara/bmsf
docs_dir: docs

nav:
  - Home: index.md
  - About: 
      - Mission & Vision: 00_About/README.md
  - Governance:
      - Structure: 01_Governance/README.md
  - Legal Compliance:
      - National Laws: 02_Legal_Compliance/National_Laws/README.md
      - International Laws: 02_Legal_Compliance/International_Laws/README.md
  - Finance:
      - Policy & Audit: 03_Finance/README.md
  - HR & Volunteers:
      - Staff & Contracts: 04_HR_and_Volunteers/Staff_Contracts/README.md
      - Training: 04_HR_and_Volunteers/Training_Modules/README.md
  - Programs & Operations:
      - National: 05_Programs_and_Operations/National_Programs/README.md
      - International: 05_Programs_and_Operations/International_Programs/README.md
  - Monitoring & Evaluation: 06_Monitoring_and_Evaluation/README.md
  - IT & Digital: 07_IT_and_Digital/README.md
  - Archives & Legacy:
      - Ritualized Scripts: 08_Archives_and_Legacy/Ritualized_Scripts/README.md
      - Multilingual Docs: 08_Archives_and_Legacy/Multilingual_Documentation/README.md

theme:
  name: material
  language: en
  features:
    - navigation.instant
    - navigation.sections
    - search.highlight
    - content.code.copy

markdown_extensions:
  - toc
  - tables
  - admonition
  - codehilite
  - footnotes
  - meta
"@

Set-Content -Path "C:\MJ-Ahmad\bmsf\mkdocs.yml" -Value $mkdocsContent
Add-Content -Path $logPath -Value "- mkdocs.yml created at root"

Write-Host "`n✅ Documentation structure and mkdocs.yml setup complete." -ForegroundColor Green
