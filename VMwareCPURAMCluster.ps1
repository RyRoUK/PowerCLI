$AllClusters = @()
Get-Cluster * | ForEach-Object {
    $clusstat = "" | Select-Object ClusterName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin
    $clusstat.ClusterName = $_.Name
    $statcpu = Get-Stat -Entity $_ -Start (get-date).AddDays(-7) -Finish (Get-Date)-MaxSamples 100 -Stat cpu.usage.average
    $statmem = Get-Stat -Entity $_ -Start (get-date).AddDays(-7) -Finish (Get-Date)-MaxSamples 100 -Stat mem.usage.average
    $cpu = $statcpu | Measure-Object -Property Value -Average -Maximum -Minimum
    $mem = $statmem | Measure-Object -Property Value -Average -Maximum -Minimum
    $clusstat.CPUMax = $cpu.Maximum
    $clusstat.CPUAvg = $cpu.Average
    $clusstat.CPUMin = $cpu.Minimum
    $clusstat.MemMax = $mem.Maximum
    $clusstat.MemAvg = $mem.Average
    $clusstat.MemMin = $mem.Minimum
    $AllClusters += $clusstat
}
$AllClusters | Select-Object ClusterName, MemMax, MemAvg, MemMin, CPUMax, CPUAvg, CPUMin | Export-Csv .\CPURAMCluster.csv -NoTypeInformation
