$properties = @{}

$properties.localStorageAgenda = 'C:\__Temp\__Agenda.csv'
$properties.localStorageAttendees = 'C:\__Temp\__Attendees.csv'
$properties.localStorageFile = 'C:\__Temp\'
$properties.localStorageLinks = 'C:\__Temp\__Links.csv'
$properties.relativeArchiveUrl = '/sites/test2archive'
$properties.url = 'https://ppse.sharepoint.com/sites/test2'

$properties.archiveUrl = 'https://ppse.sharepoint.com' + $properties.relativeArchiveUrl

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
