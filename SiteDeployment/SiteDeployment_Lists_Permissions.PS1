Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

Set-PnPListPermission -Identity 'Agenda' -Group $properties.groupNameFAM -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Agenda' -Group $properties.groupNameMembers -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Agenda' -Group $properties.groupNameVisitors -AddRole 'Read'

Set-PnPListPermission -Identity 'Attendees' -Group $properties.groupNameFAM -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Attendees' -Group $properties.groupNameMembers -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Attendees' -Group $properties.groupNameVisitors -AddRole 'Read'

Set-PnPListPermission -Identity 'Files' -Group $properties.groupNameFAM -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Files' -Group $properties.groupNameMembers -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Files' -Group $properties.groupNameVisitors -AddRole 'Read'

Set-PnPListPermission -Identity 'Links' -Group $properties.groupNameFAM -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Links' -Group $properties.groupNameMembers -AddRole 'Contribute'
Set-PnPListPermission -Identity 'Links' -Group $properties.groupNameVisitors -AddRole 'Read'

Disconnect-PnPOnline
