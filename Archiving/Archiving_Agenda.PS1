Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name $properties.account

$tabelName = 'Agenda'
$table = New-Object system.Data.DataTable $tabelName

$col1 = New-Object system.Data.DataColumn title,([string])
$col2 = New-Object system.Data.DataColumn order,([string])

$table.columns.add($col1)
$table.columns.add($col2)

Connect-PnPOnline -Url $properties.itemUrl -Credentials $cred

$pnpListItems = Get-PnPListItem -List 'Agenda'

foreach ($pnpListItem in $pnpListItems) {
	$row = $table.NewRow()

	$row.title =  $pnpListItem.FieldValues.Title
	$row.order = $pnpListItem.FieldValues.fafapp3aorder

	$table.Rows.Add($row)
}

$table | Export-Csv -Path $properties.localStorageAgenda -Delimiter ';' -Encoding 'UTF8' -NoTypeInformation

Disconnect-PnPOnline

Connect-PnPOnline -Url $properties.archiveUrl -Credentials $cred

$pnpFile = Add-PnPFile -Path $properties.localStorageAgenda -Folder $properties.localArchiveFolderUrl

Disconnect-PnPOnline
