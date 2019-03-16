Param (
	$properties,
	$status
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItem = Set-PnPListItem -List 'Overview' -Identity $properties.OverviewListItemID -Values @{'fafapp3ostatus' = $status}

Disconnect-PnPOnline
