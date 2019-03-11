Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

Remove-PnPNavigationNode -All:$true -Force:$true
Remove-PnPNavigationNode -Identity 2001 -Force:$true
Remove-PnPNavigationNode -Identity 2002 -Force:$true
Remove-PnPNavigationNode -Identity 2003 -Force:$true
Remove-PnPNavigationNode -Identity 1033 -Force:$true
Remove-PnPNavigationNode -Identity 1034 -Force:$true

$url = $properties.url + '/' + $properties.subsiteUrl + '/agenda'; $pnpNode = Add-PnPNavigationNode -Title 'Agenda' -Url $url -Location 'QuickLaunch'
$url = $properties.url + '/' + $properties.subsiteUrl + '/attendees'; $pnpNode = Add-PnPNavigationNode -Title 'Attendees' -Url $url -Location 'QuickLaunch'
$url = $properties.url + '/' + $properties.subsiteUrl + '/files'; $pnpNode = Add-PnPNavigationNode -Title 'Files' -Url $url -Location 'QuickLaunch'
$url = $properties.url + '/' + $properties.subsiteUrl + '/links'; $pnpNode = Add-PnPNavigationNode -Title 'Links' -Url $url -Location 'QuickLaunch'

Disconnect-PnPOnline
