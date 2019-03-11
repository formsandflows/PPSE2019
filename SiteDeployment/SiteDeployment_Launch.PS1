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

.\SiteDeployment_Overview_AddItem.PS1 -properties $properties

.\SiteDeployment_Web.PS1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Subsite created'
.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Creating/Setting lists and doclibs'

.\SiteDeployment_List_Agenda.PS1 -properties $properties
.\SiteDeployment_List_Attendees.PS1 -properties $properties
.\SiteDeployment_List_Links.PS1 -properties $properties

.\SiteDeployment_DocLib_Files.PS1 -properties $properties
.\SiteDeployment_DocLib_Files_ContentType.PS1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Lists and doclibs created/set'
.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Settings list/doclib permissions'

.\SiteDeployment_Lists_Permissions.PS1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Permissions set'
.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Creating new homepage'

.\SiteDeployment_Page_Homepage.PS1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Homepage created'
.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Setting the quick launch'

.\SiteDeployment_QuickLaunch.PS1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Quick launch set'
.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Adding attendees'

.\SiteDeployment_Content_Attendees.PS1 -properties $properties

.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Attendees added'
.\SiteDeployment_Overview_UpdateItem.PS1 -properties $properties -status 'Active'
.\SiteDeployment_Requests_UpdateItem.PS1 -properties $properties -status 'Done'
