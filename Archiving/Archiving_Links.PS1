Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name $properties.account

$tabelName = 'Links'
$table = New-Object system.Data.DataTable $tabelName

$col1 = New-Object system.Data.DataColumn title,([string])
$col2 = New-Object system.Data.DataColumn url,([string])
$col3 = New-Object system.Data.DataColumn urlDescription,([string])

$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)

Connect-PnPOnline -Url $properties.itemUrl -Credentials $cred

$pnpListItems = Get-PnPListItem -List 'Links'

foreach ($pnpListItem in $pnpListItems) {
	$row = $table.NewRow()

	$row.title =  $pnpListItem.FieldValues.Title
	$row.url = $pnpListItem.FieldValues.fafapp3llink.Url
	$row.urlDescription = $pnpListItem.FieldValues.fafapp3llink.Description

	$table.Rows.Add($row)
}

$table | Export-Csv -Path $properties.localStorageLinks -Delimiter ';' -Encoding 'UTF8' -NoTypeInformation

Disconnect-PnPOnline

Connect-PnPOnline -Url $properties.archiveUrl -Credentials $cred

$pnpFile = Add-PnPFile -Path $properties.localStorageLinks -Folder $properties.localArchiveFolderUrl

Disconnect-PnPOnline
