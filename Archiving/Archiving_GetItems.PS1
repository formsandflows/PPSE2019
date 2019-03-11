Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.url -Credentials $cred

$query = '<View><Query><Where><Eq><FieldRef Name="fafapp3ostatus" /><Value Type="Text">Closed</Value></Eq></Where></Query></View>'
$pnpListItems = Get-PnPListItem -List 'Overview' -Query $query

foreach ($pnpListItem in $pnpListItems) {
	$properties.overviewItems += $pnpListItem.Id
}

Disconnect-PnPOnline
