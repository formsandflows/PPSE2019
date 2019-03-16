$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$url = Get-AutomationVariable -Name 'url'

$properties = @{}

$properties.account = 'Service Account'
$properties.localStorageOverview = 'Report1_'
$properties.localStorageOverview2 = 'Report2_'
$properties.relativeUrl = $relativeUrl
$properties.url = $url + $relativeUrl

.\Reporting_1.ps1 -properties $properties
.\Reporting_2.ps1 -properties $properties
