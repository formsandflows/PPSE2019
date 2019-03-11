Param (
	$properties,
	$status
)

Connect-PnPOnline -Url $properties.url

$pnpListItem = Set-PnPListItem -List 'Overview' -Identity $properties.OverviewListItemID -Values @{'fafapp3ostatus' = $status}

Disconnect-PnPOnline
