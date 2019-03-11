Param (
	$properties
)

Connect-PnPOnline -Url $properties.suburl

$pnpCT = Get-PnPContentType -Identity 'Minutes' -InSiteHierarchy:$true
$pnpList = Get-PnPList -Identity 'Files'
$pnpCTAdded = Add-PnPContentTypeToList -List $pnpList -ContentType $pnpCT -DefaultContentType:$false

Disconnect-PnPOnline
