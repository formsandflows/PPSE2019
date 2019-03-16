Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.itemUrl -Credentials $cred
$pnpListItems = Get-PnPListItem -List 'Files'
Disconnect-PnPOnline

foreach ($pnpListItem in $pnpListItems) {
	$tabelName = 'File'
	$table = New-Object system.Data.DataTable $tabelName

	$col1 = New-Object system.Data.DataColumn name,([string])
	$col2 = New-Object system.Data.DataColumn title,([string])
	$col3 = New-Object system.Data.DataColumn order,([string])
	$col4 = New-Object system.Data.DataColumn modifiedByDisplayName,([string])
	$col5 = New-Object system.Data.DataColumn modifiedByEmail,([string])
	$col6 = New-Object system.Data.DataColumn modified,([string])

	$table.columns.add($col1)
	$table.columns.add($col2)
	$table.columns.add($col3)
	$table.columns.add($col4)
	$table.columns.add($col5)
	$table.columns.add($col6)

	$row = $table.NewRow()

	$row.name =  $pnpListItem.FieldValues.FileLeafRef
	$row.title =  $pnpListItem.FieldValues.Title
	$row.order = [math]::Round($pnpListItem.FieldValues.fafapp3forder.LookupValue)
	$row.modifiedByDisplayName = $pnpListItem.FieldValues.Editor.LookupValue
	$row.modifiedByEmail = $pnpListItem.FieldValues.Editor.Email

	$date = Get-Date($pnpListItem.FieldValues.Modified).ToUniversalTime()
	$timestamp = $date.Year.ToString()
	$timestamp += '-'
	if ($date.Month.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Month.ToString()} else {$timestamp += $date.Month.ToString()}
	$timestamp += '-'
	if ($date.Day.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Day.ToString()} else {$timestamp += $date.Day.ToString()}
	$timestamp += 'T'
	if ($date.Hour.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Hour.ToString()} else {$timestamp += $date.Hour.ToString()}
	$timestamp += ':'
	if ($date.Minute.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Minute.ToString()} else {$timestamp += $date.Minute.ToString()}
	$timestamp += ':'
	if ($date.Second.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Second.ToString()} else {$timestamp += $date.Second.ToString()}
	$timestamp += 'Z'

	$row.modified = $timestamp

	$table.Rows.Add($row)

	$file = $pnpListItem.FieldValues.FileLeafRef + '.csv'
	$table | Export-Csv -Path $file -Delimiter ';' -Encoding 'UTF8' -NoTypeInformation

	Connect-PnPOnline -Url $properties.archiveUrl -Credentials $cred
	$pnpFile = Add-PnPFile -Path $file -Folder $properties.localArchiveFolderUrl
	Disconnect-PnPOnline

	Connect-PnPOnline -Url $properties.itemUrl -Credentials $cred
	$fileRef = $pnpListItem.FieldValues.FileRef
	$pnpFile = Copy-PnPFile -SourceUrl $fileRef -TargetUrl $properties.relativeArchiveFolderUrl -OverwriteIfAlreadyExists:$true -Force:$true
	Disconnect-PnPOnline
}
