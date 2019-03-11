Param (
	$properties,
	$status
)

Connect-PnPOnline -Url $properties.url

$pnpListItem = Set-PnPListItem -List 'Requests' -Identity $properties.requestID -Values @{'fafapp3rstatus' = $status}

Disconnect-PnPOnline
