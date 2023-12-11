#!/bin/bash
#the goal of this script is to convert text to hash automatically and vice versa
#for possible password recovery or encoding on the go
main_menu() {
COLUMNS=12
echo $'\e[1;31m'
if [ /usr/bin/figlet ]
then
	figlet HASHER
else
	echo "Installing figlet..."
	sudo apt install figlet &&
	clear &&
	figlet HASHER
fi
echo '* ' "means that it is a TWO WAY hashing algorythm"
COLUMNS=12
PS3=("#main: ")
hasher=("*gnuprivacygpg" "*openssl_base64" "openssl_sha1sum" "openssl_sha256sum" "openssl_sha512sum" "*base_64" "exit")
select hash in "${hasher[@]}"; do
case $hash in
"*gnuprivacygpg")
clear
gnuprivacygpg
;;
"*openssl_base64")
clear
openssl_base64
;;
"openssl_sha1sum")
clear
openssl_sha1sum
;;
"openssl_sha256sum")
clear
openssl_sha256sum
;;
"openssl_sha512sum")
clear
openssl_sha512sum
;;
"*base_64")
clear
base_64
;;
"exit")
clear
exit
;;
*)
	echo "invalid input"
	sleep 1
	clear
	main_menu
esac
done
}
gnuprivacygpg() {
COLUMNS=12
if [ /usr/lib/gnupg ]
then
	echo "gnupg is installed.."
else
	sudo apt install gnupg
fi
if [ -n "$(gpg --list-secret-keys)" ]
then
	echo "you already have a gpg key"
	echo "continuing..."
else
	gpg --full-generate-key
fi
read -p $'\e[31mGpgKeyName?: \e[0m' gpgname
sudo gpg --export -a "$gpgname" > public_key.asc
echo "send the public_key.asc w/ set password to intended recepient"
echo "send other generated .asc file to the recipient as well..."
echo "include single quotes aound message if symbols, double if just text"
PS3=("#GPG: ")
gpg=("Encode" "Decode" "Main")
select g in "${gpg[@]}"; do
case $g in
"Encode")
read -p $'\e[31mMessage?: \e[0m' message
read -p $'\e[31mRecipient Name?: \e[0m' recip
echo $message | gpg --encrypt --armor -r "$recip" > enc.asc
;;
"Decode")
read -p $'\e[31mFile To Decrypt?: \e[0m' decf
sudo gpg --decrypt $decf
;;
"Main")
clear
main_menu
;;
esac
done
}
openssl_base64() {
COLUMNS=12
PS3=("#OB64: ")
ob64=("Encode" "Decode" "Main")
select ob in "${ob64[@]}";  do
case $ob in
"Encode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mEnter Here: \e[0m' encmsg
read -p $'\e[31mSave to file?\e[0m' reslt
if [ $reslt = "yes" ] || [ $reslt = "y" ]
then
read -p $'\e[31mFilename?(no .txt): \e[0m' filec
echo -n $encmsg | openssl enc -base64 > $filec.txt
else
echo -n $encmsg | openssl enc -base64
fi
;;
"Decode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mEncrypted Text?: \e[0m' dect
echo $dect | openssl enc -d -a
;;
"Main")
clear
main_menu
;;
esac
done
}
openssl_sha1sum() {
COLUMNS=12
PS3=("#OSHA1: ")
os1=("Encode" "Main")
select o1 in "${os1[@]}"; do
case $o1 in
"Encode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mText to Encrypt?: \e[0m' encmsg
echo -n $encmsg | openssl sha1
;;
"Main")
clear
main_menu
;;
esac
done
}
openssl_sha256sum() {
COLUMNS=12
PS3=("#OS256: ")
osha2=("Encode" "Main")
select osh in "${osha2[@]}"; do
case $osh in
"Encode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mText to Encrypt?: \e[0m' encmsg
echo -n $encmsg | openssl sha256
;;
"Main")
clear
main_menu
;;
esac
done
}
openssl_sha512sum() {
COLUMNS=12
PS3=("#OS512: ")
osha3=("Encode" "Main")
select os3 in "${osha3[@]}"; do
case $os3 in
"Encode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mText to Encrypt?: \e[0m' encmsg
echo -n $encmsg | openssl sha512
;;
"Main")
clear
main_menu
;;
esac
done
}
base_64() {
COLUMNS=12
PS3=("#B64: ")
b64=("Encode" "Decode" "Main")
select b6 in "${b64[@]}"; do
case $b6 in
"Encode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mEnter Here: \e[0m' encmsg
read -p $'\e[31mSave to file?\e[0m' reslt
if [ $reslt = "yes" ] || [ $reslt = "y" ]
then
read -p $'\e[31mFilename?(no .txt): \e[0m' filec
echo -n $encmsg | base64 > $filec.txt
else
echo -n $encmsg | base64
fi
;;
"Decode")
echo "if just text enter double quotes around message"
echo "if symbols enter single quotes around message"
read -p $'\e[31mEncrypted Text?: \e[0m' dect
echo $dect | base64 -d
;;
"Main")
clear
main_menu
;;
esac
done
}
main_menu
