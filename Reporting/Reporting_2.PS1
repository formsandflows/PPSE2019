Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name $properties.account

$tabelName = 'Report2'
$table = New-Object system.Data.DataTable $tabelName

$col1 = New-Object system.Data.DataColumn url,([string])
$col2 = New-Object system.Data.DataColumn size,([string])

$table.columns.add($col1)
$table.columns.add($col2)

Connect-PnPOnline -Url $properties.url -Credentials $cred
$query = '<View><Query><Where><Eq><FieldRef Name="fafapp3ostatus" /><Value Type="Text">Active</Value></Eq></Where></Query></View>'
$pnpListItems = Get-PnPListItem -List 'Overview' -Query $query
Disconnect-PnPOnline

foreach ($pnpListItem in $pnpListItems) {
	$row = $table.NewRow()
	
	$url = $pnpListItem.FieldValues.fafapp3ourl
	
	Connect-PnPOnline -Url $url -Credentials $cred

	$size = 0
	$pnpListItems2 = Get-PnPListItem -List 'Files'
	foreach ($pnpListItem2 in $pnpListItems2) {
		$size = $pnpListItem2.FieldValues.SMTotalFileStreamSize
	}

	Disconnect-PnPOnline -Connection $connection

	$row.url = $url
	$row.size = $size.ToString()

	$table.Rows.Add($row)
}

Connect-PnPOnline -Url $properties.url -Credentials $cred

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

$file = $properties.localStorageOverview2 + $timestamp + '.csv'
$table | Export-Csv -Path $file -Delimiter ';' -Encoding 'UTF8' -NoTypeInformation
Connect-PnPOnline -Url $properties.url

$contentType = 'Item'

$pnpFile = Add-PnPFile -Path $file -Folder 'Reports' -ContentType $contentType -Values @{'fafapp3r2reporttype'='Report 2'; 'fafapp3r2date'=$date}

Disconnect-PnPOnline
