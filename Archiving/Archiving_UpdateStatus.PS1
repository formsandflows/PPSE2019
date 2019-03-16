Param (
	$properties,
	$overviewItem,
	$status
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItem = Set-PnPListItem -List 'Overview' -Id $overviewItem -Values @{'fafapp3ostatus'=$status}

Disconnect-PnPOnline
