#!/bin/bash
# Marlboro Auto Get POINT
# Issued: 21 March 2019
# Made W/Love By Demeter16
# Any issue plz contact https://facebook.com/Achon666ju5t.mil.id
cok='cookies.txt'
login(){
	curl -s -X POST \
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
	curl -s 'https://www.marlboro.id/profile' -b $cok -c $cok
}
get_csrf(){
	curl -s 'https://www.marlboro.id/auth/login?ref_uri=/profile' --cookie-jar $cok
}
get_video(){
	curl -s 'https://www.marlboro.id/' -b $cok --cookie-jar $cok | grep -Po "(?<=data-stringid=\").*?(?=\" data-source=\")"
}
nonton_video(){
	link=$1
	ssrf=$2
	curl -sL -X POST \
	--url "https://www.marlboro.id/article/play-video/$link/update" \
	--data-urlencode "decide_csrf=$ssrf" \
	--data-urlencode 'page=undefined' \
	-b $cok --cookie-jar $cok
}
function verif_data(){
	curl -s -X POST \
	--url 'https://www.marlboro.id/auth/update-profile'\
	-d 'address=jl+aceh+asoy+geboy+809&city=339&confirm_password_chg=&decide_csrf='$1'&email=&fav_brand1=500019272&fav_brand2=500020640&interest=Travel&interest_raw=Travel&new_password_chg=&old_password_chg=&password=&phone_number=08953407244729&postalcode=0&province=30&security_answer=rihana&security_question=500001007&stop_subscribe_email_promo=true' \
	-b $cok --cookie-jar $cok \
	| jq .data.status
}
echo -n 'Do With Verif data? [y/n] '
read verif
echo -n 'Do With Watching Movie? [y/n] '
read wacing
read -p 'Your Email List: ' list
y=$(gawk -F: '{ print $1 }' $list)
x=$(gawk -F: '{ print $2 }' $list)
IFS=$'\r\n' GLOBIGNORE='*' command eval  'email=($y)'
IFS=$'\r\n' GLOBIGNORE='*' command eval  'pass=($x)'
for (( i = 0; i < "${#email[@]}"; i++ )); do
	decide_csrf=$(echo $(get_csrf) | grep -Po "(?<=name\=\"decide_csrf\" value\=\").*?(?=\" />)" | head -1)
	emails="${email[$i]}"
	echo -n "$emails | AutoLogin: "
	pw="${pass[$i]}"
	for opateuy in {1..4}; do
		ceklogin=$(login $emails $pw $decide_csrf | grep -Po "(?<=\"message\":\").*?(?=\")")
	done
	if [[ "$ceklogin" =~ 'Akun lo telah dikunci' ]]; then
		echo "Akun Dikunci (locked)"
	elif [[ "$ceklogin" =~ 'Email atau password yang lo masukan salah' ]]; then
		echo -n "Wrong Password"
	elif [[ "$ceklogin" =~ 'success' ]]; then
		echo -n "OK | "
		if [[ "$verif" = 'n' && "$wacing" = 'n' ]]; then
			echo -n "Your Point: $(get_point | grep -Po "(?<=\<span class=\"point-place\" data-current=\").*?(?=\">)")"
		fi
	else
		echo -n " | Wrong CSRF"
	fi
if [[ "$verif" = 'y' ]]; then
	gover=$(verif_data $decide_csrf)
	echo -n "Verif Data: "
	echo -n "$gover | Your Point $(get_point | grep -Po "(?<=\<span class=\"point-place\" data-current=\").*?(?=\">)")"
fi
if [[ "$wacing" = 'y' ]]; then
	if [[ !-f vid.txt ]]; then
		get_video $decide_csrf | shuf | head -4 >> vid.txt
	fi
	for nonton in $(cat vid.txt | head -4); do
		echo -n "Watching: $nonton | "
		for sepuluh in {1..10}; do
			new_csrf=$(get_point | grep -Po "(?<=name\=\"decide_csrf\" value\=\").*?(?=\" />)" | head -1)
			lalajo=$(nonton_video $nonton $new_csrf)
		done
		if [[ "$lalajo" =~ 'true' ]]; then
			echo -n "OK | Your Point $(get_point | grep -Po "(?<=\<span class=\"point-place\" data-current=\").*?(?=\">)") | "

		else
			echo -n 'BAD CSRF'
		fi
	done
	echo ''
fi
rm vid.txt
rm $cok
done
