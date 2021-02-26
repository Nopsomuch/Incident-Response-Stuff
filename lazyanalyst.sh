#!/bin/bash

# Lazy Analyst Tool
# Created 9/10/18


clear


BLACK='\033[0;30m'
WHITE='\033[1;37m'
RED='\033[0;31m'
LBLUE='\033[1;34m'
PURPLE='\033[0;35m'
YELLOW='\033[1;33m'
ORANGE='\033[0;33m'
GREEN='\033[0;32m'

     ############
  ##  Variables   ##
     ############

# All api's below are free to sign up for; enter your generated API below and you can interchange variables
# at one time or another I have used all of these but tend to switch them in an out.

vt_api='8875426f5dc10a28df1de807d7d0a588928b244b8c93a0c567fb890d52cbf42d'           # Virus Total - API
phishtank_api='bc0a78c4a241f4181ae8bf804e5f750f1c8855795714079e9882b8ceaa3b0c8b'    # Phish Tank - API
geo_api='dd0ba80f2cab4c52baf72010038a22e2'                                          # IP Geolocation.io - API
hybrid_api='c8ksscok8o84k00wkg8ss048kg8sccs484s4so0c8ogwgcow0ks00soos8gkw00s'       # Hybrid Analysis - API
screenshot_api='bcab1d3269c1795ebf1577be5240aae2'                                   # ScreenshotLayer - API
myips_api='1588145206-751345199-891866134'                                          # MyIPS - API
urlscan_api='51c54de8-959b-4c75-8f3c-5ac491568dae'                                  # URLScan.io - API
urlvoid_api='7f70b8b5f27430577beb6a0184862b6d89830894'                              # URLVoid - API
opswat_api='e81d53e0e635b90e0b946b6eb075b34d'                                       # OPSWat - MetaDefender - API
riskiq_api='c90167f7dc7c49f5c85e9ad4d7401d8c5bfb76a4c9e0c0eb8f1061a78faf419b'       # RiskIQ - API
riskiq_key='nopsomuch9@gmail.com'                                                   # RiskIQ - Key [Email Address]
sndbox_key='701b3c55-ffd1-4ed9-ae21-8ada98c729f8'									                  # SNDBOX - Key


pause(){
  read -p "Press [Enter] key to return to main menu..." fackEnterKey
}

one(){
  echo "one() called"
      pause
}

two(){
  echo "two() called"
      pause
}

three(){
  echo "three() called"
      pause
}

four(){
  echo "four() called"
      pause
}

five(){
  echo "five() called"
      pause
}

six(){
  echo "six() called"
      pause
}

banner=$(
echo -e "${WHITE} .____                                 _____                   .__                     __      "
echo -e "${WHITE} |    |    _____   ________ ___.__.   /  _  \    ____  _____   |  |   ___.__.  _______/  |_    "
echo -e "${WHITE} |    |    \__  \  \___   /<   |  |  /  /_\  \  /    \ \__  \  |  |  <   |  | /  ___/\   __\   "
echo -e "${WHITE} |    |___  / __ \_ /    /  \___  | /    |    \|   |  \ / __ \_|  |__ \___  | \___ \  |  |     "
echo -e "${WHITE} |_______ \(____  //_____ \ / ____| \____|__  /|___|  /(____  /|____/ / ____|/____  > |__|     "
echo -e "${WHITE}         \/     \/       \/ \/              \/      \/      \/        \/          \/  v.004    "
echo -e ""
)

show_menus(){
  clear
  write_header
  date
          echo -e "${WHITE}  ${RED}        [1]  ${ORANGE} URL/IP Scan ${WHITE}"
          echo -e "${WHITE}  ${RED}        [2]  ${ORANGE} URL Screenshot ${WHITE}"
          echo -e "${WHITE}  ${RED}        [3]  ${ORANGE} Phishing Scan ${WHITE}"
          echo -e "${WHITE}  ${RED}        [4]  ${ORANGE} Geo-Location ${WHITE}"
          echo -e "${WHITE}  ${RED}        [5]  ${ORANGE} Hash Lookup ${WHITE}"
          echo -e "${WHITE}  ${RED}        [6]  ${ORANGE} Exit"
}

write_header(){
#    local h="$@"
    echo "---------------------------------------------------------------------------------------------"
    echo "$banner"
    echo "---------------------------------------------------------------------------------------------"
}


url_scan(){
  echo -e ""
  echo -e "${WHITE}URL/IP Scan"
  virustotal 
  URLVoid
  metadefender
  pause
}

url_screenshot(){
  echo -e ""
  echo -e "${WHITE}URL Screenshot"
  read -p "Enter URL (ex. http://www.google.com): " ip
  echo -e ""
  screenshotlayer
  pause
}

phish_scan(){
  echo -e ""
  echo -e "${WHITE}Phishing Scan "
  read -p "Enter URL (ex. http://phishingsite.com/): " ip 
  echo -e ""
  phishtank
  pause
}

geo_location(){
  echo -e ""
  echo -e "${WHITE}Geo-Location"
  read -p "Enter IP: " ip  
  geolocation
  pause
}

hash_lookup(){
  echo -e ""
  echo -e "${WHITE}Hash Lookup"
  read -p "Enter Hash: " md5
  sndbox_hash
  pause
}

virustotal (){
  read -p "Enter URL/IP: " ip
  echo -e ""
  echo -e "Virus Total Results:"
  curl -s -X GET \
  "https://www.virustotal.com/vtapi/v2/url/report?apikey=$vt_api&resource=$ip" \
  -H 'cache-control: no-cache' | python -m json.tool | grep 'positives\|total'| sed '/permalink/d'

}

URLVoid (){
  echo -e ""
  echo -e "${WHITE}URL Void Result:"
  curl -s -X POST \
  --url "https://api.urlvoid.com/api1000/$urlvoid_api/host/$ip/scan/" \
  -H 'Cache-Control: no-cache' \ | python -m json.tool
}

metadefender(){
  echo -e ""
  echo -e "${WHITE}Meta Defender Results:"
  curl -X GET \ https://api.metadefender.com/v3/$ip \
  -H 'Authorization: apikey=$opswat_api' | python -m json.tool
}

screenshotlayer(){
  curl -s -o ~/Desktop/lazy_analyst_screenshot.jpeg --request GET \
    --url "http://api.screenshotlayer.com/api/capture?access_key=$screenshot_api&url=$ip"  \
    --header 'cache-control: no-cache' | python -m json.tool 
  echo -e "${GREEN}[+] Screenshot has been saved to your desktop!"
}

phishtank(){
  curl -s -X POST \
  'http://checkurl.phishtank.com/checkurl/?app_key=$phishtank_api&url=$ip' \
  -H 'cache-control: no-cache' | #python -c 'import sys, json; print json.load(sys.stdin)[sys.argv[1]]'
  if [[ "Verfied" = 'true' ]]; then
    echo -e "${RED}[-] This is a phishing site!"
  else
    echo -e "${Green}[+] Site has not been submitted for analysis"
    echo -e ""
  fi
}

geolocation(){
  curl -s --request GET \
  --url "https://api.ipgeolocation.io/ipgeo?apiKey=$geo_api&ip=$ip" \
  --header 'cache-control: no-cache' | python -m json.tool | grep 'continent_name\|country_code3\|country_name\|ip\|isp\|organization\|state_prov'
}

sndbox_file (){
	curl -s -X POST \
	https://api.sndbox.com/developers/files \
	-H 'apikey: $sndbox_key' \
	-F
}

sndbox_hash (){
	curl -s -X POST \
  --url "http://api.sndbox.com/developers/files/verdict/bulk" \
	-H "apikey: sndbox_key" \
	-d '{"query.hash": "GET", "query": [{ "hash": "$md5"}]}' \ | python -m json.tool

}

read_options(){
    local c
    echo -e ${GREEN}" ┌─["${ORANGE}"Lazy Analyst${GREEN}]──[${ORANGE}~${GREEN}]─["${ORANGE}"menu${GREEN}]:"
    echo -ne ${GREEN}" └─────► " ;       #### <---- Taken from the FatRAT script --- def not creative enough to come up with 


    read c
    case $c in
      1) url_scan ;;
      2) url_screenshot ;;
      3) phish_scan ;;
      4) geo_location ;;
      5) hash_lookup ;;
      6) exit 0 ;;
      *)
         echo "Read numbers...choose one..."
         pause
  esac
}


while true
do

    show_menus      # Display Menu
    read_options    # Read Menu Options
    
done
