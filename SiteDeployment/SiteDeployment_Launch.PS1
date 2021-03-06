Param (
	[string]$id,
	[string]$title,
	[string]$date
)

$appName = Get-AutomationVariable -Name 'appName'
$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$serviceAccount = Get-AutomationVariable -Name 'serviceAccount'
$url = Get-AutomationVariable -Name 'url'

$properties = @{}

$subsiteUrl = ''
for ($i = 0; $i -lt 7; $i++) {
	$subsiteUrl += Get-Random -Minimum 0 -Maximum 9
}

$properties.account = 'Service Account'
$properties.appName = $appName
$properties.relativeUrl = $relativeUrl
$properties.requestID = $id
$properties.serviceAccount = $serviceAccount
$properties.subsiteDate = Get-Date($date)
$properties.subsiteTitle = $title
$properties.subsiteUrl = $subsiteUrl
$properties.url = $url + $relativeUrl

$properties.groupNameFAM = $properties.appName + ' - FAM'
$properties.groupNameMembers = $properties.appName + ' - Members'
$properties.groupNameVisitors = $properties.appName + ' - Visitors'
$properties.suburl = $properties.url + '/' + $properties.subsiteUrl

.\SiteDeployment_Overview_AddItem.ps1 -properties $properties

.\SiteDeployment_Web.ps1 -properties $properties

$cred = Get-AutomationPSCredential -Name $properties.account
Connect-PnPOnline -Url $properties.suburl -Credentials $cred
Set-PnPWebPermission -Group $properties.groupNameFAM -AddRole 'Read'
Set-PnPWebPermission -Group $properties.groupNameMembers -AddRole 'Read'
Set-PnPWebPermission -Group $properties.groupNameVisitors -AddRole 'Read'
Set-PnPWebPermission -User $properties.$properties.serviceAccount -RemoveRole 'Full Control'
Disconnect-PnPOnline

.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Subsite created'
.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Creating/Setting lists and doclibs'

.\SiteDeployment_List_Agenda.ps1 -properties $properties
.\SiteDeployment_List_Attendees.ps1 -properties $properties
.\SiteDeployment_List_Links.ps1 -properties $properties

.\SiteDeployment_DocLib_Files.ps1 -properties $properties
.\SiteDeployment_DocLib_Files_ContentType.ps1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Lists and doclibs created/set'
.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Settings list/doclib permissions'

.\SiteDeployment_Lists_Permissions.ps1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Permissions set'
.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Creating new homepage'

.\SiteDeployment_Page_Homepage.ps1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Homepage created'
.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Setting the quick launch'

.\SiteDeployment_QuickLaunch.ps1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Quick launch set'
.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Adding attendees'

.\SiteDeployment_Content_Attendees.ps1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Attendees added'
.\SiteDeployment_Overview_UpdateItem.ps1 -properties $properties -status 'Active'
.\SiteDeployment_Requests_UpdateItem.ps1 -properties $properties -status 'Done'
