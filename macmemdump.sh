#!/bin/bash

#####################################################################################################
#                                                                                                   #
# Automating memory dumps for MacOS using osxpmem.app                                               #
# Author is not responsible for the use of this program by others; script was intended to           #
# speed up incident response efforts.                                                               #
#                   **** YOU MUST BE A LOCAL ADMIN OF THE BOX ****                                  #                                                              #
#                                                                                                   #
#####################################################################################################

BLACK='\033[0;30m'
WHITE='\033[1;37m'
RED='\033[0;31m'
LBLUE='\033[1;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'


#### Variables ####

pmem='https://github.com/google/rekall/releases/download/v1.5.1/osxpmem-2.1.post4.zip'     ## Update hardcoded version as needed
memdump='osxpmem.app'
zip='osxpmem-2.1.post4.zip'                                                                ## Update hardcoded version as needed
delzip='rm'
memcap='sudo osxpmem.app/osxpmem -o Memory_Capture/mem.aff4'
hbrew='/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
pmemosx='locate osxpmem'
homeb='locate brew'
deny='sudo spctl --master-enable'
allow='sudo spctl --master-disable'
beer='/usr/local/Homebrew'
pack='brew install wget'

# Check to see if osxpmem.app is installed on device
appInstall (){
$loc $memdump &> /dev/null
    if  [[ $memdump ]]; then
        echo -e "${GREEN}[+] Checking to see if osxpmem is installed..."
    else 
        echo -e "${RED}[-] App not found..." 
fi
}

getbrew(){
$homeb &> /dev/null
    if [[ $homeb != $beer ]]; then
        echo -e "${GREEN}[+] Homebrew is installed!" && $pack &> /dev/null 
    else 
        $hbrew && echo -e "${RED}[-] Installing HomeBrew..."
        $pack && echo -e "${RED}[-] Installing wget..."

fi
}

getfile(){
    echo "[+] Downloading file now..."
    wget $pmem &> /dev/null && uzip &> /dev/null
    echo -e "${GREEN}[+] $memdump Dowload Complete!"

}

uzip (){
    if [[ $memdump ]]; then
    unzip $zip &> /dev/null 
    echo "[+] "
    echo "[+] Unzipping file complete..."
fi
}

spdisable(){
    if [[ $deny != 'True' ]];then
        $allow
    else
        echo -e "${GREEN}[+] Permissions Look Good!"
fi
}


memdump(){
    if [[ $memdump ]]; then
        echo -e "${YELLOW}[-] Backend setup for dumping memory wait a second..."
        mkdir Memory_Capture
        spdisable
        sudo chown -R root:wheel osxpmem.app
        $memcap
        echo -e  "${GREEN} [+] Memory Dump Complete; .aff4 File in current directory!" 
fi
}

cleanup(){
    if [[ $zip ]]; then
        $delzip $zip
        echo -e "{RED} [+] ZIP FILE DELETED"
        $deny
        echo -e "{RED} [+] Install permissions restored!"
fi
}


appInstall
sleep 2s
getbrew
sleep 2s
getfile
sleep 2s
memdump
cleanup