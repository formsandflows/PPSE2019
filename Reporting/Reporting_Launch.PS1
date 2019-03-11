$relativeUrl = Get-AutomationVariable -Name 'relativeUrl'
$url = Get-AutomationVariable -Name 'url'

$properties = @{}

$properties.localStorageOverview = 'C:\__Temp\Report1_'
$properties.localStorageOverview2 = 'C:\__Temp\Report2_'
$properties.relativeUrl = $relativeUrl
$properties.url = $url + $relativeUrl

.\Reporting_1.PS1 -properties $properties
.\Reporting_2.PS1 -properties $properties
