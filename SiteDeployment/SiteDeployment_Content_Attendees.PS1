Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.url -Credentials $cred

$employees = @()

$pnpListItems = Get-PnPListItem -List 'Employees'
foreach ($pnpListItem in $pnpListItems) {
	if (($pnpListItem.FieldValues.fafapp3erole -eq 'Member') -or ($pnpListItem.FieldValues.fafapp3erole -eq 'Visitor')) {
		$employees += $pnpListItem.FieldValues.fafapp3eaccount.Email
	}
}

Disconnect-PnPOnline

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

foreach ($employee in $employees) {
	$pnpListItem = Add-PnPListItem -List 'Attendees' -Values @{'Title' = 'Attendees'; 'fafapp3a2account' = $employee}
}

Disconnect-PnPOnline
