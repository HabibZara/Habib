# install-winget.ps1
# Non-admin-friendly installer: installs module for CurrentUser and handles Repair step gracefully.

$ProgressPreference = 'SilentlyContinue'
Write-Host "Installing WinGet PowerShell module from PSGallery (CurrentUser if not elevated)..."
try {
  Install-PackageProvider -Name NuGet -Force -Scope CurrentUser -ErrorAction Stop | Out-Null
} catch {
  Write-Warning "Install-PackageProvider failed: $_. Attempting without -Scope..."
  Install-PackageProvider -Name NuGet -Force | Out-Null
}
try {
  Install-Module -Name Microsoft.WinGet.Client -Force -Repository PSGallery -Scope CurrentUser -ErrorAction Stop | Out-Null
} catch {
  Write-Warning "Install-Module failed: $_. Try running as Administrator to install for AllUsers."
}
Write-Host "Attempting to run Repair-WinGetPackageManager (may require Administrator)..."
if (Get-Command Repair-WinGetPackageManager -ErrorAction SilentlyContinue) {
  try {
    Repair-WinGetPackageManager -AllUsers -ErrorAction Stop
  } catch {
    Write-Warning "Repair-WinGetPackageManager failed: $_. Try running the Repair step from an elevated PowerShell."
  }
} else {
  Write-Host "Repair-WinGetPackageManager not available in this session. Restart PowerShell or run Repair in an elevated session."
}
Write-Host "Done."
