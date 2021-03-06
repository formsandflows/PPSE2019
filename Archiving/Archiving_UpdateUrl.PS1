Param (
	$properties,
	$overviewItem
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItem = Set-PnPListItem -List 'Overview' -Id $overviewItem -Values @{'fafapp3ourl'=$properties.archiveFolderUrl}

Disconnect-PnPOnline
