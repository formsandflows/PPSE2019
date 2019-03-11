Param (
	$properties,
	 $overviewItem
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.archiveUrl -Credentials $cred

$properties.containerTitle = $properties.itemUrl -replace ($properties.url + '/'), ''
$properties.archiveFolderUrl = $properties.archiveUrl + '/Files/' + $properties.containerTitle
$properties.localArchiveFolderUrl = 'Files/' + $properties.containerTitle
$properties.relativeArchiveFolderUrl = $properties.relativeArchiveUrl + '/Files/' + $properties.containerTitle

$pnpFolder = Add-PnPFolder -Name $properties.containerTitle -Folder 'Files'

Disconnect-PnPOnline
