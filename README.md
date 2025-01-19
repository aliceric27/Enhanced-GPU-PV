<p align="center">
  <h1 align="center">Enhanced-GPU-PV</h1>
  <p align="center">
    一個致力於使
    <br />
    Windows Hyper-V 上的 GPU 虛擬化更簡單的項目！
  </p>
</p>

<br>

## ℹ 關於

此項目基於 "Easy-GPU-PV" 項目並試圖改進它。

>GPU-PV 允許您將系統的專用或集成 GPU 分區並分配給多個 Hyper-V 虛擬機。這是 WSL2 和 Windows Sandbox 中使用的相同技術。  
Easy-GPU-PV 旨在通過自動化設置 GPU-PV 虛擬機所需的步驟來使這變得更容易。  
Easy-GPU-PV 執行以下操作...  
>1) 創建您選擇的虛擬機。
>2) 自動將 Windows 安裝到虛擬機。
>3) 分區您選擇的 GPU 並將所需的驅動程式文件複製到虛擬機。  
>4) 將 [Parsec](https://parsec.app) 安裝到虛擬機。Parsec 是一個超低延遲的遠程桌面應用程式，用於連接到虛擬機。您可以免費非商業使用 Parsec。要商業使用 Parsec，請註冊 [Parsec For Teams](https://parsec.app/teams) 帳戶。

原始項目僅允許用戶設置 Parsec，沒有 Sunshine/Moonlight 等替代方案。此外，它僅在用戶通過依賴 Parsec 應用程式的回退顯示和其隱私模式連接時向虛擬機添加虛擬顯示。  
這可能會導致一些 [問題](https://github.com/jamesstringerparsec/Easy-GPU-PV/issues/190)，並且還意味著當沒有用戶連接時螢幕會斷開，這對包括我在內的一些人造成了問題 ;-)。當連接到虛擬機時，您也會被登出。  
此更新版本允許用戶選擇是否要安裝 Sunshine 或 Parsec。它還向虛擬機添加了一個永久連接的虛擬顯示，解決了上述問題。用戶還可以在兩種不同的虛擬顯示解決方案之間進行選擇。  
一種 [解決方案](https://github.com/timminator/ParsecVDA-Always-Connected) 基於 Parsec 虛擬顯示驅動程式。另一種 [解決方案](https://github.com/timminator/Virtual-Display-Driver) 利用 [itsmikethetech](https://github.com/itsmikethetech) 的虛擬顯示驅動程式，我修改了它以便可以在此項目中遠程安裝。  
兩種解決方案都允許高解析度和高刷新率。  

與原始項目相比，最重要的更改摘要：
* 允許用戶安裝 Sunshine 或 Parsec
* 向虛擬機添加永久連接的虛擬顯示，而不依賴於 Parsec 應用程式
* 用戶可以在兩種不同的虛擬顯示解決方案之間進行選擇

次要更改：
* 安裝過程還禁用了 OneDrive 自動啟動。由於設置了本地帳戶而不是 Microsoft 帳戶，這會導致問題。
* 將語言和時區添加到安裝的可配置參數中。
* 安裝過程將顯示關閉時間設置為 "從不"。
* 自動啟用 Windows

## 先決條件：

* Windows 10 20H1+ 專業版、企業版或教育版或 Windows 11 專業版、企業版或教育版。由於更好的兼容性，建議在主機和虛擬機上使用 Windows 11。  
* 主機和虛擬機之間的 Windows 版本匹配。不匹配可能會導致兼容性問題、藍屏或其他問題。（例如，Win10 21H2 + Win10 21H2，或 Win11 21H2 + Win11 21H2）。  
* Windows 10 用戶建議安裝時關閉核顯(Intel內顯)
* 配備專用 NVIDIA/AMD GPU 或集成 Intel GPU 的桌面電腦 - 目前不支持配備 NVIDIA GPU 的筆記本電腦，但集成 Intel GPU 在筆記本電腦上可用。GPU 必須支持影片硬體編碼（NVIDIA NVENC、Intel Quicksync 或 AMD AMF）。  
* 從 Intel.com、NVIDIA.com 或 AMD.com 下載的最新 GPU 驅動程式，不要依賴設備管理器或 Windows 更新。  
* 最新的 Windows 10/11 ISO 可以從 [這裡](https://www.microsoft.com/en-gb/software-download/windows10ISO) 和 [這裡](https://www.microsoft.com/en-us/software-download/windows11) 下載 - 不要使用媒體創建工具，如果沒有直接的 ISO 下載鏈接，請按照 [此指南](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus) 操作。
* 主板上需要啟用虛擬化，並且需要在 Windows 10/11 操作系統上 [完全啟用 Hyper-V](https://docs.microsoft.com/en-us/virtualization/hyper-v-on-windows/quick-start/enable-hyper-v)（需要重啟）。  
* 允許在系統上運行 Powershell 腳本 - 通常通過在以管理員身份運行的 Powershell 中運行 "Set-ExecutionPolicy unrestricted"。
* 虛擬機首次啟動時需要互聯網連接以安裝 Parsec、虛擬顯示和音頻驅動程式。

## 運行步驟：

1. 確保您的系統符合先決條件。
2. 下載最新版本並解壓縮。
3. 在系統中搜尋 Powershell ISE 並以管理員身份運行它。
4. 在您下載的解壓縮文件夾中，打開 PreChecks.ps1 在 Powershell ISE 中並使用綠色播放按鈕運行它，並複製列出的 GPU（或需要修復的警告）。
5. 在 Powershell ISE 中打開 CopyFilesToVM.ps1 並編輯文件頂部的參數部分。關於這些參數的更多說明可以在下面找到。
6. 使用您對參數部分的更改運行 CopyFilesToVM.ps1 - 這可能需要 5-10 分鐘。
7. 在虛擬機上打開並登錄 Parsec 或 Sunshine。如果您使用 Sunshine，還需要將虛擬機與客戶端配對。
8. 之後雙擊快捷方式 "Switch Display to ParsecVDA/Virtual Display" 取決於您選擇的解決方案。您的虛擬機內的鼠標將消失。關閉主機上的窗口。使用 Parsec 或 Moonlight 連接到虛擬機。

您應該可以開始了！

## 注意事項：

- 如果您使用 Sunshine/Moonlight 解決方案，我建議您在第一次通過 Moonlight 連接後重新啟動虛擬機。  
由於某些原因，在第一次切換到虛擬顯示時，刷新率未達到設置的限制。例如，在 60hz 刷新率下，它被限制為 56 fps，可以通過像 testufo.com 這樣的網站驗證。這會導致掉幀。重新啟動後，問題不再發生。
- 連接到虛擬機可能需要長達 60 秒的時間。這可能會導致使用默認的 Moonlight 客戶端時出現問題，因為它的超時窗口為 10 秒。如果在此時間範圍內未收到生成幀，連接嘗試將超時。這可能導致需要多次嘗試才能成功連接到虛擬機。  
為了解決這個問題，我還創建了一個新的 Moonlight 構建，將此超時增加到 60 秒。您可以在 [這裡](https://github.com/timminator/Moonlight-Tailored-for-GPU-PV) 查看。
- 如果開啟 VDD 導致 HyperV 原生遠端黑畫面，請至Hyper-V管理員->右邊選單->Hyper-V設定->加強的工作階段模式原則->允許加強的工作階段模式打勾
(因為開啟虛擬畫面後，Hyper-V就需要使用加強工作階段才可以連線到虛擬機)

## 更新主機 GPU 驅動程式後升級虛擬機 GPU 驅動程式：

在更新主機 GPU 驅動程式後，更新虛擬機 GPU 驅動程式非常重要。您可以通過以下方式進行...  
1. 更新 GPU 驅動程式後關閉虛擬機並重啟主機。  
2. 以管理員身份打開 Powershell 並將目錄（CD）更改為 CopyFilesToVM.ps1 和 Update-VMGpuPartitionDriver.ps1 所在的路徑。 
3. 運行 ```Update-VMGpuPartitionDriver.ps1 -VMName "您的虛擬機名稱" -GPUName "您的 GPU 名稱"``` （Windows 10 GPU 名稱必須為 "AUTO"）

## 參數值：

有關在 CopyFilesToVM.ps1 中需要設置的參數的更多信息：

  * ```VMName = "GPUP"``` - Hyper-V 中的虛擬機名稱和主機名稱/主機名  
  * ```SourcePath = "C:\Users\james\Downloads\Win11_English_x64.iso"``` - 主機上的 Windows 10/11 ISO 路徑   
  * ```Edition    = 3``` - 保持為 3，如果不知道怎麼查看請使用  `checkOS.ps1`
  [解決方案參考](https://github.com/jamesstringerparsec/Easy-GPU-PV/issues/187#issuecomment-1183399016)
  * ```VhdFormat  = "VHDX"``` - 保持此值不變  
  * ```DiskLayout = "UEFI"``` - 保持此值不變  
  * ```SizeBytes  = 40GB``` - 磁盤大小，此處為 40GB，最小為 20GB  
  * ```MemoryAmount = 8GB``` - 記憶體大小，此處為 8GB  
  * ```CPUCores = 4``` - 分配給虛擬機的 CPU 核心數，此處為 4   
  * ```NetworkSwitch = "Default Switch"``` - 事先在 Hyper-V 管理器中創建一個新的外部網絡交換機。教程可以在 [這裡](https://www.youtube.com/watch?v=XLLcc29EZ_8&t=707s) 找到。   
  * ```VHDPath = "C:\ProgramData\Microsoft\Windows\Virtual Hard Disks\"``` - 您希望虛擬機磁盤存儲的文件夾路徑，它必須已經存在，目前設置為 Windows 11 的默認路徑  
  * ```UnattendPath = "$PSScriptRoot"+"\autounattend.xml"``` - 保持此值不變  
  * ```GPUName = "AUTO"``` - AUTO 選擇第一個可用的 GPU。在 Windows 11 上，您也可以在多 GPU 情況下使用您希望與虛擬機共享的 GPU 的確切名稱（在 Windows 10 中無法選擇 GPU，必須設置為 AUTO）    
  * ```GPUResourceAllocationPercentage = 50``` - 您希望與虛擬機共享的 GPU 百分比
  * ```Parsec = $true``` - 決定是否要安裝 Parsec
  * ```ParsecVDA = $true``` - 決定是否要安裝 Parsec 虛擬顯示解決方案
  * ```Sunshine = $true``` - 決定是否要安裝 Sunshine
  * ```VirtualDisplayDriver = $true``` - 決定是否要安裝虛擬顯示驅動程式解決方案
  * ```Team_ID = ""``` - 如果您是 Parsec For Teams 訂閱者，則為 Parsec For Teams ID  
  * ```Key = ""``` - 如果您是 Parsec For Teams 訂閱者，則為 Parsec For Teams 密鑰  
  * ```Username = "GPUVM"``` - 虛擬機 Windows 用戶名，不包括特殊字符，並且必須與您設置的 "VMName" 值不同  
  * ```Password = "CoolestPassword!"``` - 虛擬機 Windows 密碼，不能為空    
  * ```Autologon = "true"``` - 如果您希望虛擬機自動登錄到 Windows 桌面  
  * ```Language = ""``` - 僅影響鍵盤佈局和其他次要設置，語言由指定的 ISO 預定。如果您希望使用 ISO 的默認設置，請將此參數留空，如此：""
  * ```Timezone = ""``` - 如果您希望使用 ISO 的默認設置，請將此參數留空，如此：""

## 進一步說明：

- 在虛擬機上登錄 Parsec 或 Sunshine 後，始終使用 Parsec 或 Moonlight 連接到虛擬機。
- 您也可以將有關 Parsec、Sunshine 和虛擬顯示解決方案的所有四個參數設置為 false，僅創建具有 GPU-PV 支持的虛擬機，如果這是您所需要的。
- 如果您收到消息 "ERROR  : Cannot bind argument to parameter 'Path' because it is null."：這可能意味著您使用了媒體創建工具下載 ISO。不幸的是，您不能使用它，如果在 Microsoft 頁面上沒有看到直接的 ISO 下載鏈接，請按照 [此指南](https://www.nextofwindows.com/downloading-windows-10-iso-images-using-rufus) 操作。  
- 您主機上的 GPU 在設備管理器中將有一個 Microsoft 驅動程式，而不是 nvidia/intel/amd 驅動程式。只要它在設備管理器中沒有黃色三角形，它就能正常工作。  
- 必須將顯示器/HDMI 虛擬插頭插入 GPU 以允許 Parsec 捕獲螢幕。無論虛擬機的數量如何，每台主機只需要一個。您也可以使用此增強版本中使用的相同 [虛擬顯示驅動程式](https://github.com/timminator/ParsecVDA-Always-Connected)。我會很感激您能查看一下。這也允許您的主機無頭運行。
- 如果您的主機非常快，它可能會在音頻驅動程式（VB Cable）和 Parsec 顯示驅動程式安裝之前到達登錄螢幕，但不用擔心！它們應該很快安裝。當快捷方式 "Switch Display to ParsecVDA" 顯示在桌面上時，安裝完成。  
- 當 UAC 提示出現、應用程式進出全屏以及在 Parsec 中切換影片編解碼器時，螢幕可能會變黑長達 60 秒 - 不確定為什麼會發生這種情況，這是 GPU-P 機器獨有的，並且在 1280x720 時恢復速度更快。
- Vulkan 渲染器不可用，GL 遊戲可能會或可能不會工作。[這](https://www.microsoft.com/en-us/p/opencl-and-opengl-compatibility-pack/9nqpsl29bfff?SilentAuth=1&wa=wsignin1.0#activetab=pivot:overviewtab) 可能對某些 OpenGL 應用程式有幫助。  
- 如果您在機器上沒有管理員權限，這意味著您將用戶名和虛擬機名稱設置為相同，這需要不同。  
- AMD Polaris GPU（如 RX 580）目前不支持通過 GPU 虛擬化進行影片硬體編碼。  
- 要使用 Rufus 下載 Windows ISO，必須啟用 "檢查更新"。
- 由於使用最新的 Parsec 虛擬顯示驅動程式，最低操作系統版本更改為 Windows 10 21H2 專業版。

## 主項目致謝：

- [Hyper-ConvertImage](https://github.com/tabs-not-spaces/Hyper-ConvertImage) 創建了與 Windows 10 和 11 兼容的 [Convert-WindowsImage](https://github.com/MicrosoftDocs/Virtualization-Documentation/tree/master/hyperv-tools/Convert-WindowsImage) 更新版本。
- [gawainXX](https://github.com/gawainXX) 幫助測試並指出錯誤和功能改進。
- [Enhanced-GPU-PV](https://github.com/timminator/Enhanced-GPU-PV) 協助本專案建置