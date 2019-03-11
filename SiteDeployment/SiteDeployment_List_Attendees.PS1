Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name 'Service Account'

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

$title = 'Attendees'
$template = 'GenericList'
$url = 'attendees'
$hidden = $false
$enableVersioning = $true
$enableContentTypes = $false
$onQuickLaunch = $false

$pnpList = Get-PnPList -Identity $title
if ($pnpList -eq $null) {
	$pnpList = New-PnPList -Title $title -Template $template -Url $url -Hidden:$hidden -EnableVersioning:$enableVersioning -EnableContentTypes:$enableContentTypes -OnQuickLaunch:$onQuickLaunch

	Set-PnPList -Identity $title -EnableAttachments $false -EnableFolderCreation $false -BreakRoleInheritance:$true -CopyRoleAssignments:$false
	Set-PnPListPermission -User $properties.serviceAccount -Identity $title -RemoveRole 'Full Control'

	$xml = '<Field
		Type="User"
		DisplayName="Account"
		List="UserInfo"
		ShowField="ImnName"
		UserSelectionMode="0"
		UserSelectionScope="0"
		Name="fafapp3a2account">
	</Field>'
	$pnpField = Add-PnPFieldFromXml -FieldXml $xml -List $title

	$xml = '<Field
		Type="Note"
		RichText="FALSE"
		DisplayName="Memo"
		Name="fafapp3a2memo">
	</Field>'
	$pnpField = Add-PnPFieldFromXml -FieldXml $xml -List $title

	$viewTitle = 'Attendees - All'
	$fields = 'ID','LinkTitle','fafapp3a2account','fafapp3a2memo','Modified','Editor','Version'
	$qeury = '<OrderBy><FieldRef Name="Modified" Ascending="FALSE" /></OrderBy>'
	$paged = $true
	$setAsDefault = $true
	$pnpView = Add-PnPView -List $title -Title $viewTitle -Fields $fields -Query $qeury -Paged:$paged -SetAsDefault:$setAsDefault

	$pnpView = Remove-PnPView -List $title -Identity 'All Items' -Force:$true
}

Disconnect-PnPOnline
