Param (
    [string]$id
)

$relativeUrl = (Get-AzureRmAutomationVariable -ResourceGroupName "RG-PPSE-1" -AutomationAccountName "RG-PPSE-1-AA-1" -name "relativeUrl").Value
$url = (Get-AzureRmAutomationVariable -ResourceGroupName "RG-PPSE-1" -AutomationAccountName "RG-PPSE-1-AA-1" -name "url").Value

$cred = Get-AutomationPSCredential -Name 'Service Account'

$properties = @{}

$properties.url = $url + $relativeUrl

Connect-PnPOnline -Url $properties.url -Credentials $cred

Set-PnPListItemPermission -List 'Overview' -Identity $id -InheritPermissions:$true
$pnpListItem = Set-PnPListItem -List 'Overview' -Identity $id -Values @{'fafapp3ostatus' = 'Closed'}

Disconnect-PnPOnline
