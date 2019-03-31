Param (
	$properties
)

$cred = Get-AutomationPSCredential -Name $properties.account

Connect-PnPOnline -Url $properties.suburl -Credentials $cred

$title = 'Agenda'
$template = 'GenericList'
$url = 'agenda'
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
		Type="Number"
		DisplayName="Order"
		Decimals="0"
		Name="fafapp3aorder">
	</Field>'
	$pnpField = Add-PnPFieldFromXml -FieldXml $xml -List $title

	$viewTitle = 'Agenda items - All'
	$fields = 'ID','LinkTitle','fafapp3aorder','Modified','Editor','Version'
	$qeury = '<OrderBy><FieldRef Name="fafapp3aorder" Ascending="TRUE" /></OrderBy>'
	$paged = $true
	$setAsDefault = $true
	$pnpView = Add-PnPView -List $title -Title $viewTitle -Fields $fields -Query $qeury -Paged:$paged -SetAsDefault:$setAsDefault

	$pnpView = Remove-PnPView -List $title -Identity 'All Items' -Force:$true
}

Disconnect-PnPOnline
