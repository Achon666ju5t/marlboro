#!/bin/bash
# Bot Marlboro Coded By Achon666ju5t - Demeter16
date +%R
list='' #Your Email:pass list
rm vid.txt
GREEN='\e[38;5;82m'
CYAN='\e[38;5;39m'
RED='\e[38;5;196m'
YELLOW='\e[93m'
PING='\e[38;5;198m'
BLUE='\033[0;34m'
NC='\033[0m'
BLINK='\e[5m'
HIDDEN='\e[8m'
echo -n 'Started at: '
start=$(date +%R)
printf "${PING}${start}${NC}\n"
cok='marlboro.txt'
countdown() {
    secs=$1
    shift
    msg=$@
    while [ $secs -gt 0 ]
    do
        printf "\r\033[KMasih Nonton.. Tunggu  %.d $msg" $((secs--))
        sleep 1
    done
    echo
}
login(){
    curl -s -X POST --compressed \
        --url 'https://www.marlboro.id/auth/login?ref_uri=/profile'\
        -H 'Accept-Language: en-US,en;q=0.9' \
        -H 'Connection: keep-alive' \
        -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
        -H 'Host: www.marlboro.id' \
        -H 'Origin: https://www.marlboro.id' \
        -H 'Referer: https://www.marlboro.id/' \
        -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/72.0.3626.119 Safari/537.36' \
        -H 'X-Requested-With: XMLHttpRequest' \
        --data-urlencode 'email='$1'' \
        --data-urlencode 'password='$2''\
        --data-urlencode 'decide_csrf='$3'' \
        --data-urlencode 'ref_uri=%252Fprofile0' \
        --cookie-jar $cok -b $cok
}
get_point(){
    curl -s 'https://www.marlboro.id/' -b $cok -c $cok | grep -Po "(?<=<img src=\"/assets/images/icon-point.svg\"/><div>).*?(?=</div></div>)"
}
get_csrf(){
    curl -s 'https://www.marlboro.id/auth/login?ref_uri=/profile' --cookie-jar $cok
}
get_video(){
    curl -s "https://www.marlboro.id/article/$1" -b $cok --cookie-jar $cok | grep -Po "(?<=data-ref\=\"https://www.marlboro.id/discovered/article/).*?(?=\")" | sort -fsu  > vid.txt
}
submit_video(){
    curl -s -X POST -b $cok --cookie-jar $cok \
        --url 'https://www.marlboro.id/article/video-play/'$1 \
        -d 'decide_csrf='$2'&log_id='$3'&duration=30.118&total_duration=30.482667'
    }
nonton_video(){
    link=$1
    ssrf=$2
    curl -sL -X POST \
        --url "https://www.marlboro.id/article/video-play/$link" \
        --data-urlencode "decide_csrf=$ssrf" \
        --data-urlencode 'page=undefined' \
        -b $cok --cookie-jar $cok
}
printf "${YELLOW}"
jumlah='6'
wacing='y'
printf "${NC}"
y=$(gawk -F: '{ print $1 }' $list)
x=$(gawk -F: '{ print $2 }' $list)
IFS=$'\r\n' GLOBIGNORE='*' command eval  'email=($y)'
IFS=$'\r\n' GLOBIGNORE='*' command eval  'passw=($x)'
for (( i = 0; i < "${#email[@]}"; i++ )); do
    decide_csrff=$(echo $(get_csrf) | grep -Po "(?<=name\=\"decide_csrf\" value\=\").*?(?=\" />)" | head -1)
    emails="${email[$i]}"
    pw="${passw[$i]}"
    login $emails $pw $decide_csrff | grep -Po "(?<=\"message\":\").*?(?=\")" &> /dev/null
    let "sebelum=$(get_point)-25"
    if [[ ! -f vid.txt ]]; then
            printf "[!]${RED} No Video Found [!]\n[+]${CYAN} Getting Video . . . . [+]\n"
            baca=$(cat article.txt | head -1)
            cat article.txt | grep -v $baca > article.txt.tmp && mv article.txt.tmp article.txt
            echo "$baca" >> article.txt
            get_video $baca
        fi
        printf "${RED}[x] ${YELLOW}$emails ${RED}"
    for ((e=0;e<$jumlah; e++ )); do
        decide_csrf=$(echo $(get_csrf) | grep -Po "(?<=name\=\"decide_csrf\" value\=\").*?(?=\" />)" | head -1)
        ceklogin=$(login $emails $pw $decide_csrf | grep -Po "(?<=\"message\":\").*?(?=\")")
        if [[ "$ceklogin" =~ 'Akun lo telah dikunci' ]]; then
            echo "Akun Dikunci (locked)"
            continue
        elif [[ "$ceklogin" =~ 'Email atau password yang lo masukan salah' ]]; then
            echo -n "Wrong Password"
        elif [[ "$ceklogin" =~ 'success' ]]; then
            if [[ "$verif" = 'n' && "$wacing" = 'n' && "$klaim" = 'n' ]]; then
                printf "${CYAN}[+] ${GREEN}Your Point: $(get_point | grep -Po "(?<=\<span class=\"point-place\" data-current=\").*?(?=\">)") ${NC}"
            fi
            if [[ "$wacing" = 'y' ]]; then
                for nonton in $(cat vid.txt | shuf | head -1); do
                    cat vid.txt | grep -v $nonton > vid.txt.tmp && mv vid.txt.tmp vid.txt &> /dev/null
                    echo "$nonton" >> r.txt
                    printf "${CYAN}[BOT] "
                    lalajo=$(nonton_video $nonton $decide_csrf)
                    for ((oo=0; oo<3; oo++)); do
                        lid=$(echo $lalajo | jq .data.log_id | tr -d \")
                        nobar=$(submit_video $nonton $decide_csrf $lid | jq .data.finished)
                        if [[ "$nobar" = 'true' ]]; then
                            decide_csrf=$(echo $(get_csrf) | grep -Po "(?<=name\=\"decide_csrf\" value\=\").*?(?=\" />)" | head -1)
                            echo -en "${GREEN}[OK] | ${YELLOW}"
                            break
                        elif [[ "$lalajo" =~ "Action is not allowed" ]]; then
                            echo -n "BAD CSRF"
                            break
                        else
                            sleep 29
                        fi
                    done
                done
            fi
        else
            # echo "$ceklogin"
            echo -n "Wrong CSRF | "
        fi
    done
    ceklogin=$(login $emails $pw $decide_csrf | grep -Po "(?<=\"message\":\").*?(?=\")")
    point=$(get_point)
    let "akhir=${point}-${sebelum}"
    printf "${sebelum} -> ${point} | Nambah: ${GREEN}${akhir} [+]\n${NC}"
    rm $cok
    mv r.txt vid.txt
done
echo "start from ${start} | Ends at: $(date +%R)"
