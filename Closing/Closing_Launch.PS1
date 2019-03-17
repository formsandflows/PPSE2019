Param (
    [string]$id
)

$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$url = Get-AutomationVariable -Name 'url'

$cred = Get-AutomationPSCredential -Name 'Service Account'

$properties = @{}

$properties.url = $url + $relativeUrl

Connect-PnPOnline -Url $properties.url -Credentials $cred

Set-PnPListItemPermission -List 'Overview' -Identity $id -InheritPermissions:$true
$pnpListItem = Set-PnPListItem -List 'Overview' -Identity $id -Values @{'fafapp3ostatus' = 'Closed'}

$date = $pnpListItem.FieldValues.fafapp3odate
$dateLocal = $date.ToLocalTime()

$timestamp = $dateLocal.Year.ToString()
$timestamp += '-'
if ($dateLocal.Month.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $dateLocal.Month.ToString()} else {$timestamp += $dateLocal.Month.ToString()}
$timestamp += '-'
if ($dateLocal.Day.ToString().Length -eq 1) {$timestamp += '0'; $timestamp += $dateLocal.Day.ToString()} else {$timestamp += $dateLocal.Day.ToString()}

$title = 'Emails'
$contentType = 'Item'
$pnpItem = Add-PnPListItem -List $title -ContentType $contentType -Values @{'Title'=$timestamp;'fafapp3e2emailtype'='Closed'}

Disconnect-PnPOnline
