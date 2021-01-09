#!/bin/bash

#colours
RED='\033[0;31m'
YELLOW='\033[0;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
#Bold
BGREEN="\033[1;32m"
BRED="\033[1;31m"
BBLUE="\033[1;34m"
BPURPLE="\033[1;35m"
BWHITE="\033[1;37m"
BYELLOW="\033[1;33m"
BCYAN="\033[1;36m"
# Underline
UBLACK="\033[4;30m"       # Black
URED="\033[4;31m"         # Red
UGREEN="\033[4;32m"       # BGREEN
UYELLOW="\033[4;33m"      # YELLOW
UBLUE="\033[4;34m"        # Blue
UPURPLE="\033[4;35m"      # Purple
UCYAN="\033[4;36m"        # Cyan
UWHITE="\033[4;37m"       # White
#BoldUnderline
BUBGREEN="\033[1;32m\033[4;32m"
BURED="\033[1;31m\033[4;31m"
BUBLUE="\033[1;34m\033[4;34m" 
BUPURPLE="\033[1;35m\033[4;35m"
BUWHITE="\033[1;37m\033[4;37m"
#NoColour
NC='\033[0m'
	
#network check
echo
echo -e "${BUBLUE}Network Check${NC}"
if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
	echo -e "${BGREEN}[-]Internet Connection Stable"
else
	echo -e "${RED}[-]Internet Is Down"
	exit  
fi

echo
echo -e "${BGREEN}Installing Git"
apt install git -y

#wordlist check
echo
echo -e "${BUBLUE}Wordlist Check${NC}"
if [[ ! -e "/usr/share/wordlists/SecLists/Discovery/Web-Content/directory-list-2.3-medium.txt" && ! -e "/usr/share/wordlists/dirbuster/directory-list-2.3-medium.txt" ]]
then
	echo -e "${BYELLOW}[-]Wordlist Not Found. Downloading It From SecLists. Download Directory \"/usr/share/wordlists/SecLists\"${NC}"
	git clone https://github.com/danielmiessler/SecLists.git /usr/share/wordlists/SecLists 1> /dev/null
else
	echo -e "${BGREEN}[-]Wordlist Found${NC}"
fi

#password list check
echo
echo -e "${BUBLUE}Passwordlist Check${NC}"
if [[ ! -e "/usr/share/wordlists/rockyou.txt.gz" && ! -e "/usr/share/wordlists/rockyou.txt" ]]
then
	echo -e "${BYELLOW}[-]Passwordlist Not Found. Downloading RockYou.txt From Github${NC}"
	wget https://github.com/brannondorsey/naive-hashcat/releases/download/data/rockyou.txt
	mv rockyou.txt /usr/share/wordlists/
elif [[ ! -e "/usr/share/wordlists/rockyou.txt" && -e "/usr/share/wordlists/rockyou.txt.gz" ]]
then
	echo -e "${BYELLOW}[-]Compressed Wordlist rockyou.txt.gz Found. Unpacking....${NC}"
	gzip -d /usr/share/wordlists/rockyou.txt.gz
elif [[ -e "/usr/share/wordlists/rockyou.txt" ]]
then
	echo -e "${BGREEN}[-]Password List Found!${NC}"
fi

#software check
echo 
echo -e "${BUBLUE}Installing Dependencies and Relevant Tools/Programs${NC}"

if xterm -v > /dev/null
then
	echo -e "${BGREEN}[-]Xterm is alredy installed.${NC}"
else
	echo -e "${BYELLOW}[-]Installing Xterm${NC}"
	apt install xterm -y
fi

if nmap -V > /dev/null
then
	echo -e "${BGREEN}[-]NMAP is already installed.${NC}"
else
	echo -e "${BYELLOW}[-]Installing NMAP${NC}"
	apt install nmap -y
fi

if ruby -v > /dev/null
then
	echo -e "${BGREEN}[-]Ruby is already installed.${NC}"
else
	echo -e "${BYELLOW}[-]Installing Ruby${NC}"
	apt install ruby -y 
fi


echo -e "${BYELLOW}[-]Installing tty-progressbar${NC}"
gem install tty-progressbar
echo -e "${BYELLOW}[-]Installing pastel${NC}"
gem install pastel

if gobuster --help >& /dev/null
then
	echo -e "${BGREEN}[-]Gobuster is already installed.${NC}"
else
	echo -e "${BYELLOW}[-]Installing Gobuster${NC}"
	apt install gobuster -y
fi

if jq -V > /dev/null
then
	echo -e "${BGREEN}[-]JQ(JSON Parser) is already installed.${NC}"
else
	echo -e "${BYELLOW}[-]Installing JQ(JSON Parser)${NC}"
	apt install jq -y
fi

if xmlstarlet --version > /dev/null
then
	echo -e "${BGREEN}[-]XMLStarlet is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing XMLStarlet(XML Parser)${NC}"
	apt install xmlstarlet -y
fi

if parallel --version > /dev/null
then
	echo -e "${BGREEN}[-]Parallel is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing Parallel${NC}"
	apt install parallel -y
fi

if aircrack-ng -u >& /dev/null
then
	echo -e "${BGREEN}[-]Aircrack-ng suite is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing Aircrack-ng Suite${NC}"
	apt install aircrack-ng -y
fi

if python --version > /dev/null
then
	echo -e "${BGREEN}[-]Python is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing Python${NC}"
	apt install python -y && apt install python3 -y
fi

if [[ -e /usr/bin/searchsploit ]]
then
	echo -e "${BGREEN}[-]Searchsploit is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing Searchsploit${NC}"
	git clone https://github.com/offensive-security/exploitdb.git /opt/exploitdb
	ln -sf /opt/exploitdb/searchsploit /usr/local/bin/searchsploit
fi

if curl -V > /dev/null
then
	echo -e "${BGREEN}[-]CURL is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing CURL${NC}"
	apt install curl -y
fi

if python3 -m pip -V > /dev/null
then
	echo -e "${BGREEN}[-]Pip is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing Pip${NC}"
	apt install python3-pip -y
fi

if theHarvester --help >& /dev/null
then
	echo -e "${BGREEN}[-]theHarverster is already installed${NC}"
else
	echo -e "${BYELLOW}[-]Installing theHarvester${NC}"
	python3 -m pip install theHarvester 
fi

chmod +x bellaseye

