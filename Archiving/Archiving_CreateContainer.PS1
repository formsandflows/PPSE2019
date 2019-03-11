Param (
	$properties,
	 $overviewItem
)

Connect-PnPOnline -Url $properties.archiveUrl

$properties.containerTitle = $properties.itemUrl -replace ($properties.url + '/'), ''
$properties.archiveFolderUrl = $properties.archiveUrl + '/Files/' + $properties.containerTitle
$properties.localArchiveFolderUrl = 'Files/' + $properties.containerTitle
$properties.relativeArchiveFolderUrl = $properties.relativeArchiveUrl + '/Files/' + $properties.containerTitle

$pnpFolder = Add-PnPFolder -Name $properties.containerTitle -Folder 'Files'

Disconnect-PnPOnline
