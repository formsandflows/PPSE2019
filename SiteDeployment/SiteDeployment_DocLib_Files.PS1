Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

$title = 'Files'
$template = 'DocumentLibrary'
$url = 'files'
$hidden = $false
$enableVersioning = $true
$enableContentTypes = $true
$onQuickLaunch = $false

$pnpList = Get-PnPList -Identity $title
if ($pnpList -eq $null) {
	$pnpList = New-PnPList -Title $title -Template $template -Url $url -Hidden:$hidden -EnableVersioning:$enableVersioning -EnableContentTypes:$enableContentTypes -OnQuickLaunch:$onQuickLaunch

	Set-PnPList -Identity $title -EnableFolderCreation $true -BreakRoleInheritance:$true -CopyRoleAssignments:$false -EnableMinorVersions $false
	Set-PnPListPermission -User 's_app1@ppse.onmicrosoft.com' -Identity $title -RemoveRole 'Full Control'

	$pnpCT = Get-PnPContentType -Identity 'Minutes' -InSiteHierarchy:$true
	$pnpList = Get-PnPList -Identity 'Files'
	$pnpCTAdded = Add-PnPContentTypeToList -List $pnpList -ContentType $pnpCT -DefaultContentType:$false

	$pnpListAgenda = Get-PnPList -Identity 'Agenda'
	$xml = '<Field
		Type="Lookup"
		List="' + $pnpListAgenda.Id.ToString() + '"
		ShowField="fafapp3aorder"
		DisplayName="Order"
		Name="fafapp3forder">
	</Field>'
	$pnpField = Add-PnPFieldFromXml -FieldXml $xml -List $title

	$viewTitle = 'Files - All'
	$fields = 'ID','DocIcon','ContentType','LinkFilename','Title','fafapp3forder','Modified','Editor','Version'
	$qeury = '<OrderBy><FieldRef Name="fafapp3forder" Ascending="TRUE" /></OrderBy>'
	$paged = $true
	$setAsDefault = $true
	$pnpView = Add-PnPView -List $title -Title $viewTitle -Fields $fields -Query $qeury -Paged:$paged -SetAsDefault:$setAsDefault

	$pnpView = Remove-PnPView -List $title -Identity 'All Documents' -Force:$true
}

Disconnect-PnPOnline
