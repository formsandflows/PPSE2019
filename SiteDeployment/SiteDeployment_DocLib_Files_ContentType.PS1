Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

$pnpCT = Get-PnPContentType -Identity 'Minutes' -InSiteHierarchy:$true
$pnpList = Get-PnPList -Identity 'Files'
$pnpCTAdded = Add-PnPContentTypeToList -List $pnpList -ContentType $pnpCT -DefaultContentType:$false

Disconnect-PnPOnline
