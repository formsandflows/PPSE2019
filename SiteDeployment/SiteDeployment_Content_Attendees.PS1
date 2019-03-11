Param (
	$properties
)

Connect-PnPOnline -Url $properties.url

$employees = @()

$pnpListItems = Get-PnPListItem -List 'Employees'
foreach ($pnpListItem in $pnpListItems) {
	if (($pnpListItem.FieldVAlues.fafapp3erole -eq 'Member') -or ($pnpListItem.FieldVAlues.fafapp3erole -eq 'Visitor')) {
		$employees += $pnpListItem.FieldValues.fafapp3eaccount.Email
	}
}

Disconnect-PnPOnline

Connect-PnPOnline -Url $properties.suburl

foreach ($employee in $employees) {
	$pnpListItem = Add-PnPListItem -List 'Attendees' -Values @{'Title' = 'Attendees'; 'fafapp3a2account' = $employee}
}

Disconnect-PnPOnline
