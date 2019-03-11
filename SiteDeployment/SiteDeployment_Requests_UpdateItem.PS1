Param (
	$properties,
	$status
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItem = Set-PnPListItem -List 'Requests' -Identity $properties.requestID -Values @{'fafapp3rstatus' = $status}

Disconnect-PnPOnline
