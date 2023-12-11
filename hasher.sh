#!/bin/bash
#the goal of this script is to convert text to hash automatically and vice versa
#for possible password recovery or encoding on the go
if [ /usr/bin/mcrypt ]
then
        echo "mcrypt is installed.."
else
        sudo apt install mcrypt &&
        clear
fi
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
echo ' - ' "means that it is a TWO WAY hashing algorythm"
echo '-------------------------------------------------'
echo ""

COLUMNS=12
PS3=("#main: ")
hasher=("-AES" "-Arcfour" "-ARIA" "-RSA" "-Rijndael" "-Serpent" "-Twofish" "-gnuprivacygpg" "-openssl_base64" "openssl_sha1sum" "openssl_sha256sum" "openssl_sha512sum" "-base_64" "exit")
select hash in "${hasher[@]}"; do
case $hash in
"-AES")
echo -en '\n'
aes
echo -en '\n'
;;
"-Arcfour")
echo -en '\n'
arcfour
echo -en '\n'
;;
"-ARIA")
echo -en '\n'
aria
echo -en '\n'
;;
"-RSA")
echo -en '\n'
rsa_enc
echo -en '\n'
;;
"-Rijndael")
echo -en '\n'
rijn
echo -en '\n'
;;
"-Serpent")
echo -en '\n'
serpent
echo -en '\n'
;;
"-Twofish")
echo -en '\n'
twofish
echo -en '\n'
;;
"-gnuprivacygpg")
echo -en '\n'
gnuprivacygpg
echo -en '\n'
;;
"-openssl_base64")
echo -en '\n'
openssl_base64
echo -en '\n'
;;
"openssl_sha1sum")
echo -en '\n'
openssl_sha1sum
echo -en '\n'
;;
"openssl_sha256sum")
echo -en '\n'
openssl_sha256sum
echo -en '\n'
;;
"openssl_sha512sum")
echo -en '\n'
openssl_sha512sum
echo -en '\n'
;;
"-base_64")
echo -en '\n'
base_64
echo -en '\n'
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
aes() {
COLUMNS=12
read -p $'\e[31mKeySize?(128,192,256): \e[0m' keysize
read -p $'\e[31mecb, cbc, ofb, ctr, cfb8, cbf1, cfb: \e[0m' var0
echo "REMEMBER YOUR CHOICES!"
PS3=("#aes: ")
aesk=("Encrypt" "Decrypt" "Main")
select ae in "${aesk[@]}"; do
case $ae in
"Encrypt")
read -p $'\e[31mMessage?: \e[0m' encmsg
read -p $'\e[31mPass?: \e[0m' pass
read -p $'\e[31mFileToWrite?: \e[0m' outfile
echo $encmsg | openssl enc -e -k $pass -aes-$keysize-$var0 -base64 -iter 20 > $outfile
;;
"Decrypt")
read -p $'\e[31mPass?: \e[0m' passw
read -p $'\e[31mfile?: \e[0m' infile
sudo openssl enc -d -k $passw -in $infile -aes-$keysize-$var0 -a -iter 20
;;
"Main")
clear
main_menu
;;
esac
done
}
arcfour() {
COLUMNS=12
PS3=("#arcf: ")
arcfour=("Encrypt" "Decrypt" "Main")
select arc in "${arcfour[@]}"; do
case $arc in
"Encrypt")
echo "you must first make a file to encrypt"
read -p $'\e[31mName of file?: \e[0m' fname
touch $fname
read -p $'\e[31mMessage to encrypt?: \e[0m' encmsg
echo $encmsg > $fname
sudo mcrypt -a arcfour -b $fname &&
sudo shred $fname &&
sudo rm $fname
echo "your file has been encrypted, and the original copy has been"
echo "obfuscated and deleted. you can find you file with a new extension"
;;
"Decrypt")
read -p $'\e[31mFiletoDecrypt?: \e[0m' decfile
sudo mcrypt -d -a arcfour -b $decfile
;;
"Main")
clear
main_menu
;;
esac
done
}
aria() {
COLUMNS=12
read -p $'\e[31mKeySize?(128,192,256): \e[0m' keysize
read -p $'\e[31mecb, cbc, ofb, ctr, cfb8, cbf1, cfb: \e[0m' var0
echo "REMEMBER YOUR CHOICES!"
PS3=("#aria: ")
ariaa=("Encrypt" "Decrypt" "Main")
select ar in "${ariaa[@]}"; do
case $ar in
"Encrypt")
read -p $'\e[31mMessage?: \e[0m' encmsg
read -p $'\e[31mPass?: \e[0m' pass
read -p $'\e[31mFileToWrite?: \e[0m' outfile
echo $encmsg | openssl enc -e -k $pass -aria-$keysize-$var0 -a -iter 20 > $outfile
;;
"Decrypt")
read -p $'\e[31mPass?: \e[0m' passw
read -p $'\e[31mfile?: \e[0m' infile
sudo openssl enc -d -k $passw -in $infile -aria-$keysize-$var0 -a -iter 20
;;
"Main")
clear
main_menu
;;
esac
done
}
rijn() {
COLUMNS=12
PS3=("#rijn: ")
rijinnc=("Encrypt" "Decrypt" "Main")
select ri in "${rijinnc[@]}"; do
case $ri in
"Encrypt")
echo "you must first make a file to encrypt"
read -p $'\e[31mName of file?: \e[0m' fname
touch $fname
read -p $'\e[31mMessage to encrypt?: \e[0m' encmsg
echo $encmsg > $fname
read -p $'\e[31mHash Mode?(cbc or ctr): \e[0m' hmode
sudo mcrypt -a rijndael-256 -b -m $hmode $fname &&
sudo shred $fname &&
sudo rm $fname
echo "you file has been encrypted, and the original copy has been"
echo "obfuscated and deleted. you can find you file with a new extension"
;;
"Decrypt")
read -p $'\e[31mFiletoDecrypt?: \e[0m' decfile
sudo mcrypt -d -a rijndael-256 -b $decfile
;;
"Main")
clear
main_menu
;;
esac
done
}
rsa_enc() {
echo "generating rsa pubkey for encryption and decoding"
read -p $'\e[31mName of private keyfile?: \e[0m' keyname
read -p $'\e[31mName of public keyfile?: \e[0m' key
sudo openssl genpkey -algorithm RSA -out $keyname.pem -aes256
sudo openssl rsa -pubout -in $keyname.pem -out $key.pem
echo "you need these files for rsa encryption and decryption"
echo "but delete them when you are done with transmission"
echo "REMEMBER THE PASSWORD YOU SET OR YOU DATA IS GONE FOREVER"
COLUMNS=12
PS3=("#rsa: ")
rsa=("Encrypt" "Decrypt" "Main")
select rs in "${rsa[@]}"; do
case $rs in
"Encrypt")
read -p $'\e[31mMessage?: \e[0m' encmsg
read -p $'\e[31mOutfile?: \e[0m' outfile
echo -n $encmsg | sudo openssl rsautl -encrypt -pubin -inkey $key.pem -out $outfile
;;
"Decrypt")
read -p $'\e[31mEncrypted File?: \e[0m' infile
sudo openssl rsautl -decrypt -inkey $keyname.pem -in $infile
;;
"Main")
clear
main_menu
;;
esac
done
}
serpent() {
COLUMNS=12
PS3=("#serp: ")
serrrp=("Encrypt" "Decrypt" "Main")
select serr in "${serrrp[@]}"; do
case $serr in
"Encrypt")
echo "you must first make a file to encrypt"
read -p $'\e[31mName of file?: \e[0m' fname
touch $fname
read -p $'\31mMessage to Encrypt?: \e[0m' encmsg
echo $encmsg > $fname
read -p $'\e[31mHash Mode?(cbc or ctr): \e[0m' hmode
sudo mcrypt -a serpent -b -m $hmode $fname &&
sudo shred $fname &&
sudo rm $fname
echo "your file has been encrypted, and the original copy has been"
echo "obfuscated and deleted. you can find you file with a new extension"
;;
"Decrypt")
read -p $'\e[31mFiletoDecrypt?: \e[0m' decfile
sleep 0.5
sudo mcrypt -d -a serpent -b $decfile
;;
"Main")
clear
main_menu
;;
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
twofish() {
COLUMNS=12
PS3=("#twofsh: ")
twofi=("Encrypt" "Decrypt" "Main")
select tw in "${twofi[@]}"; do
case $tw in
"Encrypt")
echo "you must first make a file to encrypt"
read -p $'\e[31mName of file?: \e[0m' fname
touch $fname
read -p $'\31mMessage to Encrypt?: \e[0m' encmsg
echo $encmsg > $fname
read -p $'\e[31mHash Mode?(cbc or ctr): \e[0m' hmode
sudo mcrypt -a twofish -b -m $hmode $fname &&
sudo shred $fname &&
sudo rm $fname
echo "your file has been encrypted, and the original copy has been"
echo "obfuscated and deleted. you can find you file with a new extension"
;;
"Decrypt")
read -p $'\e[31mFiletoDecrypt?: \e[0m' decfile
sleep 0.5
sudo mcrypt -d -a twofish -b $decfile
;;
"Main")
clear
main_menu
;;
esac
done
}
main_menu
