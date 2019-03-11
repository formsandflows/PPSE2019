Param (
	$properties
)

Connect-PnPOnline -Url $properties.suburl

$title = 'Links'
$template = 'GenericList'
$url = 'links'
$hidden = $false
$enableVersioning = $true
$enableContentTypes = $false
$onQuickLaunch = $false

$pnpList = Get-PnPList -Identity $title
if ($pnpList -eq $null) {
	$pnpList = New-PnPList -Title $title -Template $template -Url $url -Hidden:$hidden -EnableVersioning:$enableVersioning -EnableContentTypes:$enableContentTypes -OnQuickLaunch:$onQuickLaunch

	Set-PnPList -Identity $title -EnableAttachments $false -EnableFolderCreation $false -BreakRoleInheritance:$true -CopyRoleAssignments:$false
	Set-PnPListPermission -User 's_app1@ppse.onmicrosoft.com' -Identity $title -RemoveRole 'Full Control'

	$xml = '<Field
		Type="URL"
		DisplayName="Link"
		Name="fafapp3llink">
	</Field>'
	$pnpField = Add-PnPFieldFromXml -FieldXml $xml -List $title

	Set-PnPField -List $title -Identity 'Title' -Values @{DefaultValue='Link'}

	$viewTitle = 'Links - All'
	$fields = 'ID','LinkTitle','fafapp3llink','Modified','Editor','Version'
	$qeury = '<OrderBy><FieldRef Name="Modified" Ascending="FALSE" /></OrderBy>'
	$paged = $true
	$setAsDefault = $true
	$pnpView = Add-PnPView -List $title -Title $viewTitle -Fields $fields -Query $qeury -Paged:$paged -SetAsDefault:$setAsDefault

	$pnpView = Remove-PnPView -List $title -Identity 'All Items' -Force:$true
}

Disconnect-PnPOnline
