$properties = @{}

$properties.localStorageOverview = 'C:\__Temp\Report1_'
$properties.localStorageOverview2 = 'C:\__Temp\Report2_'
$properties.url = 'https://ppse.sharepoint.com/sites/test2'

.\Reporting_1.PS1 -properties $properties
.\Reporting_2.PS1 -properties $properties
