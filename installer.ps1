$apps = @("Logical Gates Simulator" , "Codeblocks")
$targets = @("logical_gates_simulator_setup.msi", "codeblocks-20.03mingw-setup.exe")
$installerUrls = @(
    "https://netix.dl.sourceforge.net/project/gatesim/1.4/GateSimSetup-1.4.msi?viasf=1",
    "https://netix.dl.sourceforge.net/project/codeblocks/Binaries/20.03/Windows/codeblocks-20.03-setup.exe?viasf=1"
)
$installerDirs = @("C:\Program Files (x86)\Steve Kollmansberger\Logic Gate Simulator\GatesWpf.exe" , "C:\Program Files\CodeBlocks\codeblocks.exe")



function aminLoggy {

    <#
   .SYNOPSIS
   chalk js but for powershell made by amin :).

   .DESCRIPTION
   writes text to the console with specified colors. 
   each part of the text can have a different color.


   .PARAMETER Message
   the message containing each part text and color in this format "text1&&color1||text2&&color2...".

   .EXAMPLE
   amin-loggy "This is &&Red|| Awsome && Green"

   This example writes "This is" in red and "This is" in green to the console.
   #>


   param (
       [string]$Message
       
   )

   $parts = $Message.Split("||")| Where-Object { $_ -ne "" }
   foreach ($part in $parts) {
       $part = $part.Trim()
       
       $partInfo = $part.Split("&&")| Where-Object { $_ -ne "" }
       
       if ($partInfo.Length -eq 2) {
        $text = $partInfo[0]
        $color = $partInfo[1]
    } else {
      
        $text = "$($part) "
        $color = "White"
    }
      Write-Host -NoNewline $text -ForegroundColor $color
   }

   Write-Host ""
} 


aminLoggy "Code blocks && Red || and || logical gates simulator && Green || one click installer made by || Amin Abbar && Cyan "
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""

for ($i = 0; $i -lt $targets.Length; $i++) {
    $preMessage = "[|| ($($i + 1)/$($targets.Length)) && Yellow || $($apps[$i]) && Cyan ||] ||"
   
   
    aminLoggy "[$($i + 1)/2] && Green || Installing || $($apps[$i]) ... && Cyan"
    
    $target = $targets[$i]
    $installerUrl = $installerUrls[$i]
    $runPath =  Split-Path -Parent $MyInvocation.MyCommand.Path
    $localPath = Join-Path -Path $runPath -ChildPath $target
    $installerPath = Join-Path -Path "$env:TEMP" -ChildPath $target
    $tempPath = Join-Path -Path "$env:TEMP" -ChildPath $target

    
    $isInstalled = Test-Path $installerDirs[$i]
    if($isInstalled){
        aminLoggy "$($apps[$i]) && Yellow || is already installed. && Green" 
        continue  
    }


    if (Test-Path $localPath) {
        $installerPath = $localPath
        aminLoggy "$preMessage  Using local installer file: ||  $target && Yellow" 
    } else {
        aminLoggy "$preMessage  didn't find the installer in the script directory "
        aminLoggy "$preMessage downloading the installer: && Red ||  $target && Yellow"

        #Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath removed because of windows 7 incompatibility :(
        if( $host.version.Major -gt 2 ){
           
            Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath
           
        }else{
            [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.SecurityProtocolType] 'Ssl3, Tls, Tls11, Tls12'
            $webClient = New-Object System.Net.WebClient
            $webClient.DownloadFile($installerUrl, $installerPath)
            $webClient.Dispose()
        }
       
        

        aminLoggy "$preMessage  Installer downloading completed: && Green ||  $target && Yellow" 
    }

    aminLoggy "$preMessage   Running the installer : ||  $target && Yellow" 
    if($apps[$i] -eq "Logical Gates Simulator" ){
        $shortcutPath = [System.IO.Path]::Combine([System.Environment]::GetFolderPath('Desktop'), 'Logic Gate Simulator.lnk')

        $wScriptShell = New-Object -ComObject WScript.Shell
        $shortcut = $wScriptShell.CreateShortcut($shortcutPath)
        $shortcut.TargetPath = $installerDirs[$i]
        
        $shortcut.WorkingDirectory = "C:\Program Files (x86)\Steve Kollmansberger\Logic Gate Simulator"
        $shortcut.WindowStyle = 1
        $shortcut.Description = "Logic Gate Simulator"
        $shortcut.IconLocation = "$($installerDirs[$i]),0"
 
        $shortcut.Save()
    }
    if ($installerPath -match '\.exe$') {
        Start-Process -FilePath $installerPath -ArgumentList "/S" -Wait
        
    } 
    elseif ($installerPath -match '\.msi$') {
        Start-Process -FilePath "msiexec.exe" -ArgumentList "/i `"$installerPath`" /quiet" -Wait
    }
    aminLoggy "$preMessage   Installation complete : && Green||  $target && Yellow" 

    if (Test-Path $tempPath) {
      
       
       
        aminLoggy "$preMessage  Cleaning up temp files: || $target && Yellow"
       Remove-Item $installerPath
       aminLoggy "$preMessage Cleanup complete:  || $target && Yellow"
    }
}