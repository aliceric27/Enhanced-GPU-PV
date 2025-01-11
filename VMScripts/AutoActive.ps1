# 檢查是否以系統管理員權限執行  
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)  
if (-not $isAdmin) {  
    Write-Host "錯誤：請以系統管理員權限執行此腳本" -ForegroundColor Red  
    Write-Host "請右鍵點選腳本，選擇「以系統管理員身分執行」" -ForegroundColor Yellow  
    pause  
    exit 1  
}  

# 設定 TLS 1.2  
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12  

try {  
    Write-Host "開始Windows HWID啟用程序..." -ForegroundColor Cyan  
    
    # 設定臨時檔案路徑  
    $tempFile = Join-Path $env:TEMP "HWID_Activation.cmd"  
    
    # 下載啟用腳本  
    $url = "https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/Separate-Files-Version/Activators/HWID_Activation.cmd"  
    Write-Host "正在下載啟用檔案..." -ForegroundColor Yellow  
    
    # 下載檔案  
    Invoke-WebRequest -Uri $url -OutFile $tempFile -UseBasicParsing  
    
    if (Test-Path $tempFile) {  
        Write-Host "檔案下載成功，開始執行啟用程序..." -ForegroundColor Green  
        
        # 執行cmd檔案  
        Start-Process "cmd.exe" -ArgumentList "/c `"$tempFile`"" -Wait -NoNewWindow  
        
        # 清理臨時檔案  
        Remove-Item $tempFile -Force  
        Write-Host "啟用程序完成，臨時檔案已清理" -ForegroundColor Green  
    } else {  
        Write-Host "錯誤：無法下載啟用檔案" -ForegroundColor Red  
    }  
}  
catch {  
    Write-Host "執行過程中發生錯誤：" -ForegroundColor Red  
    Write-Host $_.Exception.Message -ForegroundColor Red  
}  
finally {  
    Write-Host "`n程序完成，按任意鍵結束..." -ForegroundColor Cyan  
    pause  
}  