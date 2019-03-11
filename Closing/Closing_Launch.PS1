Param (
    [string]$id = 4
)

$properties = @{}

$properties.url = 'https://ppse.sharepoint.com/sites/test2'

Connect-PnPOnline -Url $properties.url

Set-PnPListItemPermission -List 'Overview' -Identity $id -InheritPermissions:$true
$pnpListItem = Set-PnPListItem -List 'Overview' -Identity $id -Values @{'fafapp3ostatus' = 'Closed'}

Disconnect-PnPOnline
