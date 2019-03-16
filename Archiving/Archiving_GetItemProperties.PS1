Param (
	$properties,
	$overviewItem
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItem = Get-PnPListItem -List 'Overview' -Id $overviewItem

$properties.itemDate = Get-Date($pnpListItem.FieldValues.fafapp3odate)
$properties.itemTitle = $pnpListItem.Title
$properties.itemUrl = $pnpListItem.FieldValues.fafapp3ourl

Disconnect-PnPOnline
