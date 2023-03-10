# Generated by ChatGPT3
# In this script, a try-catch block is used to handle any errors that may occur during the execution of the script. The script exits with a status code of 1 if all updates are successfully downloaded, 1 if no updates are found for the specified OS version, or 1 if an error occurs during the script execution.

param (
    [Parameter(Mandatory=$True)]
    [ValidateSet("8", "10", "11", "2012", "2012R2", "2016", "2019", "2022")]
    [string]$OSVersion,
    [Parameter(Mandatory=$True)]
    [ValidateScript({ Test-Path $_ -PathType Container })]
    [string]$Path
)

try {
    # Get a list of all available updates for the specified OS version
    $updates = Get-WindowsUpdate -MicrosoftUpdate -AcceptAll -IncludePreviewUpdates -IgnoreUserInput |
        Where-Object { $_.Product.Contains("Windows $OSVersion") }

    if ($updates) {
        # Loop through each update and download it
        foreach ($update in $updates)
        {
            # Create a directory for the update
            New-Item -ItemType Directory -Path "$Path\$($update.Title)" | Out-Null

            # Download the update
            $update.Download("$Path\$($update.Title)")

            # Display a progress bar while the update is downloading
            while ($update.IsDownloaded -ne $True)
            {
                Write-Progress -Activity "Downloading $($update.Title) update" -Status "$($update.DownloadProgress)% complete" -PercentComplete $update.DownloadProgress
                Start-Sleep -Seconds 1
            }
        }

        # Confirm that the updates were downloaded
        Write-Host "All updates have been downloaded to $Path"
        exit 0
    } else {
        Write-Host "No updates found for Windows $OSVersion. Please check the spelling of the OS version and try again."
        exit 1
    }
} catch {
    Write-Host "An error occurred: $_"
    exit 1
}

