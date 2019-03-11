$appName = Get-AutomationVariable -Name 'appName'
$relativeArchiveUrl = Get-AutomationVariable -Name 'relativeArchiveUrl'
$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$serviceAccount = Get-AutomationVariable -Name 'serviceAccount'
$url = Get-AutomationVariable -Name 'url'

$properties = @{}

$properties.archiveUrl = $url + $relativeArchiveUrl
$properties.localStorageAgenda = 'Agenda.csv'
$properties.localStorageAttendees = 'Attendees.csv'
$properties.localStorageFile = ''
$properties.localStorageLinks = 'Links.csv'
$properties.overviewItems = @()
$properties.relativeArchiveUrl = $relativeArchiveUrl
$properties.relativeUrl = $relativeUrl
$properties.url = $url + $relativeUrl

.\Archiving_GetItems.PS1 -properties $properties

$overviewItems = $properties.overviewItems
foreach ($overviewItem in $overviewItems) {
    .\Archiving_GetItemProperties.PS1 -properties $properties -overviewItem $overviewItem
    .\Archiving_UpdateStatus.PS1 -properties $properties -overviewItem $overviewItem -status 'Archiving...'

    .\Archiving_CreateContainer.PS1 -properties $properties -overviewItem $overviewItem

    .\Archiving_Agenda.PS1 -properties $properties
    .\Archiving_Attendees.PS1 -properties $properties
    .\Archiving_Links.PS1 -properties $properties

    .\Archiving_Files.PS1 -properties $properties

    .\Archiving_UpdateUrl.PS1 -properties $properties -overviewItem $overviewItem
    .\Archiving_UpdateStatus.PS1 -properties $properties -overviewItem $overviewItem -status 'Archived'
}
