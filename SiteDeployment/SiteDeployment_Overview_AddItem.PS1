Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.url -Credentials $cred

$pnpListItem = Add-PnPListItem -List 'Overview' -Values @{'Title' = $properties.subsiteTitle; 'fafapp3ourl' = $properties.suburl; 'fafapp3odate' = $properties.subsiteDate; 'fafapp3ostatus' = 'Creating subsite'}

$properties.OverviewListItemID = $pnpListItem.Id

Set-PnPListItemPermission -List 'Overview' -Identity $properties.OverviewListItemID -Group $properties.groupNameFAM  -AddRole 'Contribute' -ClearExisting:$true
Set-PnPListItemPermission -List 'Overview' -Identity $properties.OverviewListItemID -Group $properties.groupNameMembers  -AddRole 'Contribute'
Set-PnPListItemPermission -List 'Overview' -Identity $properties.OverviewListItemID -Group $properties.groupNameVisitors  -AddRole 'Read'

Set-PnPListItemPermission -List 'Overview' -Identity $properties.OverviewListItemID -User $properties.serviceAccount  -RemoveRole 'Full Control'

Disconnect-PnPOnline
