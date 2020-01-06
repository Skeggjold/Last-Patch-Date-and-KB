class Data
{
   [string] $ComputerName
   [string] $HotFixID
   [string] $Description
   [string] $InstalledBy
   [string]	$InstalledOn
}

function Hotfixreport ([string] $filePath ){ 
    $items = New-Object -TypeName "System.Collections.ArrayList"
    $computers = Get-Content C:\complist.txt    
    $ErrorActionPreference = 'Stop'
        
    ForEach ($computer in $computers) {   
        try{
            $result = Get-HotFix -cn $computer | Sort-Object InstalledOn -Descending |  Select-Object PSComputerName, HotFixID, Description, InstalledBy, InstalledOn |Select-Object -First 1 
            foreach ($r in $result){
                $data = [Data]::new()
                $data.ComputerName = $r.PSComputerName
                $data.HotFixID =$r.HotFixID
                $data.Description =$r.Description
                $data.InstalledBy =$r.InstalledBy
                $data.InstalledOn =$r.InstalledOn

                $items.Add($data)
            }
        }catch{
            Write-Warning "Error with $($computer)`r`n$_.Exception.Message"
        }
    }

    $items | Export-Csv -Path $filePAth
}  

Hotfixreport "$env:USERPROFILE\Desktop\HotFixResults.csv" 