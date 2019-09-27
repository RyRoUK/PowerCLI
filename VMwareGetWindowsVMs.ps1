Get-VM | Where-Object {$_.Guest -like "*Windows*"} `
       | Select-Object Name, @{N="Configured OS";E={$_.ExtensionData.Config.GuestFullname}} `
       | Export-Csv AWSWindowsVMs.csv -NoTypeInformation -UseCulture