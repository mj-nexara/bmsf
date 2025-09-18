# Update-BMSF-Finance-HR.ps1
# Purpose: Enrich docs/03_Finance and docs/04_HR_and_Volunteers with inheritable, audit-ready structure

$docsPath = "C:\MJ-Ahmad\bmsf\bmsf-docs\docs"
$logPath = "$docsPath\update_log.yaml"

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

# Finance Substructure
$financeFolders = @(
    "03_Finance/Donation_Sources",
    "03_Finance/Fund_Receiving_Protocols",
    "03_Finance/Disbursement_Policy",
    "03_Finance/Budget_Tracking",
    "03_Finance/Audit_Reports"
)

# HR & Volunteers Substructure
$hrFolders = @(
    "04_HR_and_Volunteers/Staff_Contracts",
    "04_HR_and_Volunteers/Volunteer_Management",
    "04_HR_and_Volunteers/Honorarium_and_Compensation",
    "04_HR_and_Volunteers/Training_and_Ethics",
    "04_HR_and_Volunteers/Field_Deployment_Records"
)

# Create Finance folders and README.md
foreach ($folder in $financeFolders) {
    $fullPath = Join-Path $docsPath $folder
    Confirm-And-CreateFolder -path $fullPath -label $folder
    CreateMarkdown -folder $fullPath -filename "README" -title $folder
}

# Create HR folders and README.md
foreach ($folder in $hrFolders) {
    $fullPath = Join-Path $docsPath $folder
    Confirm-And-CreateFolder -path $fullPath -label $folder
    CreateMarkdown -folder $fullPath -filename "README" -title $folder
}

Write-Host "`n✅ Finance and HR documentation structure updated successfully." -ForegroundColor Green
