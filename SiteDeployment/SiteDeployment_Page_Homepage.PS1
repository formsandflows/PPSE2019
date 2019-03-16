Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

$pnpPage = Add-PnPClientSidePage -Name 'Homepage' -CommentsEnabled:$false -Publish:$false
$imageUrl = $properties.url + '/SiteAssets/Logo.jpg'
$pnpWebPart = Add-PnPClientSideWebPart -Page 'Homepage.aspx' -DefaultWebPartType 'Image' -WebPartProperties @{imageSource=$imageUrl}

$homePage = Get-PnPClientSidePage -Identity 'Homepage.aspx'
$homePage.RemovePageHeader()
$homePage.Save()

$pnpPage = Set-PnPClientSidePage -Identity 'Homepage' -Publish:$true

Set-PnPHomePage -RootFolderRelativeUrl 'SitePages/Homepage.aspx'

Disconnect-PnPOnline
