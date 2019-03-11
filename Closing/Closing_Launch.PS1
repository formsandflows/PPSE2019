Param (
    [string]$id
)

$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$url = Get-AutomationVariable -Name 'url'

$cred = Get-AutomationPSCredential -Name 'Service Account'

$properties = @{}

$properties.url = $url + $relativeUrl

Connect-PnPOnline -Url $properties.url -Credentials $cred

Set-PnPListItemPermission -List 'Overview' -Identity $id -InheritPermissions:$true
$pnpListItem = Set-PnPListItem -List 'Overview' -Identity $id -Values @{'fafapp3ostatus' = 'Closed'}

Disconnect-PnPOnline
