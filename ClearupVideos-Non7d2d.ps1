net use T: /DELETE
net use T: \\10.22.1.99\shield

If (Test-Path T: ) {
    Write-Host "Just reconnected T: drive" -ForegroundColor Black -BackgroundColor Green
    }
Else {
    Write-Host "Couldn't connect T: drive, quitting.." -ForegroundColor Red -BackgroundColor Black
}
    
$date=Get-Date -Format yyyy-MM-dd
$VideosBackupDir = "T:\Gaming\Videos\"
$videoBackup = $VideosBackupDir+$date
$VideoDir = "C:\Users\manni\Videos"

If (Test-Path $VideosBackupDir ) {} Else { New-Item -ItemType Directory -Path $videoBackup -Confirm:$false -Force}

 $videos = Get-ChildItem $VideoDir -Recurse
 # Filter out seven days
 $videos = $videos | ? { ($_.Name -contains "7 Days to Die") -eq $false }
 $videos = $videos | ? { ($_.PSIsContainer -eq $false) }
 If ( !$videos ) { 
    Write-Host "No non 7days videos on the C drive, so press any key to quit...." -ForegroundColor Green -BackgroundColor Black;
    $null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
    # Start-Sleep -Seconds 5
    Exit
}
 Else {
    $backupFolder = New-Item -ItemType Directory -Path $videoBackup -Confirm:$false -Force
 }

 # Copy all video dirs across

Write-Host "Dealing with video directory..." -ForegroundColor White -BackgroundColor Green
$videos | % { 
    Write-Host "Dealing with $_.FullName" -ForegroundColor Cyan -BackgroundColor Black
    Copy-Item -Path $_.FullName -Destination $backupFolder -Confirm:$false -Force
    }
Write-Host "Removing videos from C drive." -ForegroundColor White -BackgroundColor Green
$videos | % { Remove-Item $_.FullName -Recurse -Force -Confirm:$false } 

Write-Host "Copied and cleared video directory non Seven Days to Die videos to $videoBackup" -ForegroundColor White -BackgroundColor Green

Write-Host -NoNewLine 'Script completed. press any key to exit...' -ForegroundColor Green -BackgroundColor Red; 
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');