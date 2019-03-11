Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

$tabelName = 'Report1'
$table = New-Object system.Data.DataTable $tabelName

$col1 = New-Object system.Data.DataColumn title,([string])
$col2 = New-Object system.Data.DataColumn url,([string])
$col3 = New-Object system.Data.DataColumn date,([string])
$col4 = New-Object system.Data.DataColumn status,([string])

$table.columns.add($col1)
$table.columns.add($col2)
$table.columns.add($col3)
$table.columns.add($col4)

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItems = Get-PnPListItem -List 'Overview'

foreach ($pnpListItem in $pnpListItems) {
	$row = $table.NewRow()

	$row.title = $pnpListItem.FieldValues.Title
	$row.url = $pnpListItem.FieldValues.fafapp3ourl
	$date = Get-Date($pnpListItem.FieldValues.fafapp3odate)
	$timestamp = $date.Year.ToString()
	$timestamp += '-'
	if ($date.Month.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Month.ToString()} else {$timestamp += $date.Month.ToString()}
	$timestamp += '-'
	if ($date.Day.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Day.ToString()} else {$timestamp += $date.Day.ToString()}
	$row.date = $timestamp
	$row.status = $pnpListItem.FieldValues.fafapp3ostatus

	$table.Rows.Add($row)
}

$date = Get-Date
$timestamp = $date.Year.ToString()
$timestamp += '-'
if ($date.Month.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Month.ToString()} else {$timestamp += $date.Month.ToString()}
$timestamp += '-'
if ($date.Day.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Day.ToString()} else {$timestamp += $date.Day.ToString()}
$timestamp += 'T'
if ($date.Hour.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Hour.ToString()} else {$timestamp += $date.Hour.ToString()}
$timestamp += '-'
if ($date.Minute.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Minute.ToString()} else {$timestamp += $date.Minute.ToString()}
$timestamp += '-'
if ($date.Second.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $date.Second.ToString()} else {$timestamp += $date.Second.ToString()}
$timestamp += 'Z'

$file = $properties.localStorageOverview + $timestamp + '.csv'
$table | Export-Csv -Path $file -Delimiter ';' -Encoding 'UTF8' -NoTypeInformation

$pnpFile = Add-PnPFile -Path $file -Folder 'Reports'

Disconnect-PnPOnline
