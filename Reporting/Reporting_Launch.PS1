$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$url = Get-AutomationVariable -Name 'url'

$properties = @{}

$properties.localStorageOverview = 'Report1_'
$properties.localStorageOverview2 = 'Report2_'
$properties.relativeUrl = $relativeUrl
$properties.url = $url + $relativeUrl

.\Reporting_1.PS1 -properties $properties
.\Reporting_2.PS1 -properties $properties
