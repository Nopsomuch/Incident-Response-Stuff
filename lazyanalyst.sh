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

vt_api='ADD API KEY HERE'         						    # Virus Total - API
phishtank_api='ADD API KEY HERE'   						    # Phish Tank - API
geo_api='ADD API KEY HERE'                                                          # IP Geolocation.io - API
hybrid_api='ADD API KEY HERE'      						    # Hybrid Analysis - API
screenshot_api='ADD API KEY HERE'                                                   # ScreenshotLayer - API
myips_api='ADD API KEY HERE'                                                        # MyIPS - API
urlscan_api='ADD API KEY HERE'                              			    # URLScan.io - API
urlvoid_api='ADD API KEY HERE'                         				    # URLVoid - API
opswat_api='ADD API KEY HERE'                          			            # OPSWat - MetaDefender - API
riskiq_api='ADD API KEY HERE'    						    # RiskIQ - API
riskiq_key='ADD API KEY HERE'                                                       # RiskIQ - Key [Email Address]
sndbox_key='ADD API KEY HERE'					                    # SNDBOX - Key


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
