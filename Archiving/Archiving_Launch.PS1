$appName = Get-AutomationVariable -Name 'appName'
$relativeArchiveUrl = Get-AutomationVariable -Name 'relativeArchiveUrl'
$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$serviceAccount = Get-AutomationVariable -Name 'serviceAccount'
$url = Get-AutomationVariable -Name 'url'

$properties = @{}

$properties.account = 'Service Account'
$properties.archiveUrl = $url + $relativeArchiveUrl
$properties.localStorageAgenda = 'Agenda.csv'
$properties.localStorageAttendees = 'Attendees.csv'
$properties.localStorageLinks = 'Links.csv'
$properties.overviewItems = @()
$properties.relativeArchiveUrl = $relativeArchiveUrl
$properties.relativeUrl = $relativeUrl
$properties.url = $url + $relativeUrl

.\Archiving_GetItems.ps1 -properties $properties

$overviewItems = $properties.overviewItems
foreach ($overviewItem in $overviewItems) {
    .\Archiving_GetItemProperties.ps1 -properties $properties -overviewItem $overviewItem
    .\Archiving_UpdateStatus.ps1 -properties $properties -overviewItem $overviewItem -status 'Archiving...'

    .\Archiving_CreateContainer.ps1 -properties $properties

    .\Archiving_Agenda.ps1 -properties $properties
    .\Archiving_Attendees.ps1 -properties $properties
    .\Archiving_Links.ps1 -properties $properties

    .\Archiving_Files.ps1 -properties $properties

    .\Archiving_UpdateUrl.ps1 -properties $properties -overviewItem $overviewItem
    .\Archiving_UpdateStatus.ps1 -properties $properties -overviewItem $overviewItem -status 'Archived'
}
