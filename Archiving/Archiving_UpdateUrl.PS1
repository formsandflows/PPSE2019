Param (
	$properties,
	$overviewItem
)

Connect-PnPOnline -Url $properties.url

$pnpListItem = Set-PnPListItem -List 'Overview' -Id $overviewItem -Values @{'fafapp3ourl'=$properties.archiveFolderUrl}

Disconnect-PnPOnline
