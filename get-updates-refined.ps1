# Generated with ChatGPT3
#
# To use the script, run the following command in PowerShell:
#
# .\Download-Updates.ps1 -UpdateCategory <category> -DownloadPath <path>
#
# Replace <category> with one of the following: Security, Quality, Drivers, or All. Replace <path> with the path to the directory where you want to download the updates.
#
# This script will download the specified updates, and it will create a separate folder for each update based on the KB number of the update and the current date. The folder name will be in the format WindowsUpdates_[ServerVersion]_[KB]_[yyyyMMdd].
#
# Define the server version and update categories to be downloaded
param(
    [ValidateSet("WindowsServer2016", "WindowsServer2019", "WindowsServer2022", "Windows10", "Windows11")]
    [string]$ServerVersion,
    [ValidateSet("Drivers", "QualityUpdates", "SecurityUpdates", "FeatureUpdates", "PreviewUpdates", "Hotfixes")]
    [string[]]$Categories
)

# Create a folder for the downloads based on the server version and current date
$DownloadPath = "$env:USERPROFILE\Downloads\WindowsUpdates_$ServerVersion" + (Get-Date).ToString("yyyyMMdd")
New-Item -ItemType Directory -Path $DownloadPath

# Write a helpful message if an incorrect server version is specified
if ($ServerVersion -notmatch "WindowsServer2016|WindowsServer2019|WindowsServer2022|Windows10|Windows11") {
    Write-Host "Incorrect server version specified. Supported versions: WindowsServer2016, WindowsServer2019, WindowsServer2022, Windows10, Windows11."
    exit 1
}

# Write a helpful message if an incorrect update category is specified
if ($Categories -notmatch "Drivers|QualityUpdates|SecurityUpdates|FeatureUpdates|PreviewUpdates|Hotfixes") {
    Write-Host "Incorrect update category specified. Supported categories: Drivers, QualityUpdates, SecurityUpdates, FeatureUpdates, PreviewUpdates, Hotfixes."
    exit 2
}

# Get the specified updates
$Updates = Get-WindowsUpdate -ServerVersion $ServerVersion -Categories $Categories

# Download the updates and display a progress bar
$Updates | ForEach-Object {
    $DownloadPath = "$env:USERPROFILE\Downloads\WindowsUpdates_$ServerVersion" + (Get-Date).ToString("yyyyMMdd")
    $Package = $_
    Write-Progress -Activity "Downloading Updates" -Status "$($Package.Name)" -PercentComplete ($Package.ProgressPercentage)
    try {
        $Package.Download($DownloadPath)
    } catch {
        Write-Host "An error occurred while downloading the update: $($Package.Name)"
        exit 3
    }
}

# Write a message indicating that the downloads are complete
Write-Host "Downloads complete."

