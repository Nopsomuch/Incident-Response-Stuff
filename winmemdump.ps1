
## Script preforms a memory dump on Windows devices ONLY!


function appdl {
    cls
    Write-Host ""
    cd\
    mkdir Memory_Forensics
    cd Memory_Forensics
    Write-Host "[+] Downloading Dumpit.exe to preform memory dump.."
    Write-Host ""
    $url = "https://github.com/thimbleweed/All-In-USB/archive/master.zip"
    wget $url -OutFile "All-In-USB-master.zip"
    Write-Host "[+] File has been downloaded!"
    sleep 5
    Write-Host ".."
    Write-Host ".."
    Write-Host "[-] Unzipping File..."
    Expand-Archive C:\Memory_Forensics\All-In-USB-master.zip
    Write-Host "[+] Folder has been unzipped!"

}

function memdump {
    Write-Host ""
    appdl
    cd All-In-USB-master\All-In-USB-master\utilities\DumpIt
    .\DumpIt.exe
    Write-Host ".."
    Write-Host "[+] Dumping memory..."
    Write-Host ".."
    Write-Host "[+] .raw file is in: Memory_Forensics\All-In-USB-master\All-In-USB-master\utilities\DumpIt\" sleep 2

}

function remDump {
    Write-Host ""
    Write-Host "[*] Please close out of DumpIt.exe!!"
    sleep 5
    cd\
    $chdir = "cd\"
    rawFile
    $input = Read-Host "Do you want to remove the folder Memory_Forensics? [Y/N]"
    $cover = Remove-Item C:\Memory_Forensics
    if ($remdump -eq "y"){$chdir;$cover; Write-Host "Removing DumpIt.exe from box." -ForegroundColor White -BackgroundColor Green;sleep 2;exit}
    elseif ($remdump -eq "n"){Write-Host "I wouldn't leave that there if I were you..." -ForegroundColor White -BackgroundColor Red;sleep 2;exit}
}

function rawFile {
    Write-Host ""
    $input = Read-Host "Have you copied the .raw file to removeable media? [Y/N]"
    if ($rawfile -eq "y"){Write-Host "Good and stuff" -ForegroundColor White -BackgroundColor Green}
    elseif  ($rawFile -eq "n"){Write-Host "It's about to be deleted get on it!" -ForegroundColor White -BackgroundColor Red}
}

function mainmen {
    Write-Host ""
    $again = Read-Host "[+] Back to Main Menu? [Y/N]"
    Write-Host ""
    if ($again -eq "y"){mainmen}
    elseif ($again -eq "n"){Write-Host "Memory Dumpyard Out!"; exit}
    elseif ($again -ne "y" -or $again -ne "n"){exit}
}

function trash {
    Write-Host "Recover Deleted Files"
}

function usbHistory {
    Write-Host ""
    Write-Host "       USB History            "
    Write-Host "[Must be done locally on device]"; sleep 5
    Get-ItemProperty -Path HKLM:\SYSTEM\CurrentControlSet\Enum\USBSTOR\*\* 
}

function menu {
    cls
    Write-Host ""
    Write-Host "Windows Memory Dump Automation Station"
    Write-Host ""
    Write-Host "[1] Memory Dump"
    Write-Host "[2] Recover Deleted Files [UNDER CONSTRUCTION]"
    Write-Host "[3] USB History           [UNDER CONSTRUCTION]"
    Write-Host ""
    Write-Host ""
    $input = Read-Host "[+] Pick an option"
    if ($input -eq 0){exit}
    elseif ($input -eq 1){memdump;remdump}
    elseif ($input -eq 2){trash}
    elseif ($input -eq 3){usbHistory}

}

menu 

