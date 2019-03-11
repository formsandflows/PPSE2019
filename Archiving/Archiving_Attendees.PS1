Param (
	$properties
)

$tabelName = "Attendees"
$table = New-Object system.Data.DataTable $tabName

$col1 = New-Object system.Data.DataColumn title,([string])
$col2 = New-Object system.Data.DataColumn displayName,([string])
$col3 = New-Object system.Data.DataColumn email,([string])
$col4 = New-Object system.Data.DataColumn memo,([string])

$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)

Connect-PnPOnline -Url $properties.itemUrl

$pnpListItems = Get-PnPListItem -List 'Attendees'

foreach ($pnpListItem in $pnpListItems) {
	$row = $table.NewRow()

	$row.title =  $pnpListItem.FieldValues.Title
	$row.displayName = $pnpListItem.FieldValues.fafapp3a2account.LookupValue
	$row.email = $pnpListItem.FieldValues.fafapp3a2account.Email
	$row.memo = $pnpListItem.FieldValues.fafapp3a2memo

	$table.Rows.Add($row)
}

$table | Export-Csv -Path $properties.localStorageAttendees -Delimiter ';' -Encoding 'UTF8' -NoTypeInformation

Disconnect-PnPOnline

Connect-PnPOnline -Url $properties.archiveUrl

$pnpFile = Add-PnPFile -Path $properties.localStorageAttendees -Folder $properties.localArchiveFolderUrl


Disconnect-PnPOnline