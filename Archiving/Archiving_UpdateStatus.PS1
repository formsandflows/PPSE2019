Param (
	$properties,
	$overviewItem,
	$status
)

Connect-PnPOnline -Url $properties.url

$pnpListItem = Set-PnPListItem -List 'Overview' -Id $overviewItem -Values @{'fafapp3ostatus'=$status}

Disconnect-PnPOnline
