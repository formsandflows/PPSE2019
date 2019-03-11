Param (
	$properties
)

Connect-PnPOnline -Url $properties.url

$breakInheritance = $true
$description = ''
$inheritNavigation = $true
$locale = '1033'
$template = 'STS'
$title = $properties.subsiteTitle
$url = $properties.subsiteUrl

$relativeUrl = $properties.relativeUrl + '/' + $url
$pnpSubWebs = Get-pnpSubWebs
$exists = $false
foreach ($pnpSubWeb in $pnpSubWebs) {
	if ($pnpSubWeb.ServerRelativeUrl -eq $relativeUrl) {
		$exists = $true
	}
}
if (!$exists) {
	New-PnPWeb -Title $title -Url $url -Description $description -Locale $locale -Template $template -BreakInheritance:$breakInheritance -InheritNavigation:$inheritNavigation
}

Disconnect-PnPOnline
