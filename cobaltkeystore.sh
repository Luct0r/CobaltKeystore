#!/bin/bash
# Converts an SSL CA bundle into a Java KeyStore, suitable for Cobalt Strike.

echo "
_________       ___.          .__   __     ____  __.             _________ __                        
\_   ___ \  ____\_ |__ _____  |  |_/  |_  |    |/ _|____ ___.__./   _____//  |_  ___________   ____  
/    \  \/ /  _ \| __ \\__  \ |  |\   __\ |      <_/ __ <   |  |\_____  \\   __\/  _ \_  __ \_/ __ \ 
\     \___(  <_> ) \_\ \/ __ \|  |_|  |   |    |  \  ___/\___  |/        \|  | (  <_> )  | \/\  ___/ 
 \______  /\____/|___  (____  /____/__|   |____|__ \___  > ____/_______  /|__|  \____/|__|    \___  >
        \/           \/     \/                    \/   \/\/            \/                         \/
"

display_usage() {
	echo "Usage:   ./cobaltkeystore.sh .crt .ca-bundle .key FQDN output.store"
	echo "Example: ./cobaltkeystore.sh /path/to/domain.crt /path/to/domain.ca-bundle /path/to/domain.key *.domain.com /path/to/save/domain.store"
	echo
	}

# Check whether user had supplied -h or --help. If yes display usage.
if [[ ( $1 == "-h") ||  $1 == "--help" ]]; then
	display_usage
	exit 0
fi

# Simple supplied arguments check, displays usage if wrong.
if [  $# -ne 5 ]; then
	display_usage
	exit 1
fi

# Check if openssl is available.
if [ $(command -v openssl) ]; then
	true
else
	echo -e "\e[31m[-] Please install openssl.\e[39m"
	exit 1
fi

# Check if java is available.
if [ $(command -v java) ]; then
	true
else
	echo -e "\e[31m[-] Please install Java.\e[39m"
	exit 1
fi

# Check if keytool is available.
if [ $(command -v keytool) ]; then
	true
else
	echo -e "\e[31m[-] Please install the Java Developer Kit.\e[39m"
	exit 1
fi

read -p "[+] Enter a password for the keystore: " -es password
echo
echo

cert_path=$1
cabundle_path=$2
key_path=$3
cert_fqdn=$4
out_file=$5

echo -e "\e[32m[+] Beginning conversion...\e[39m"
echo
cat $cert_path $cabundle_path > /tmp/ssl-all.pem
openssl pkcs12 -export -name $cert_fqdn -in /tmp/ssl-all.pem -inkey $key_path -out /tmp/cert.pkcs12 --passout pass:$password
echo -e "\e[32m[+] Created PKCS12 certificate out of provided PEM files.\e[39m"
echo
keytool -importkeystore -destkeystore $out_file -deststorepass $password -destkeypass $password -srckeystore /tmp/cert.pkcs12 -srcstoretype pkcs12 -srcstorepass $password -alias $cert_fqdn
echo
echo -e "\e[32m[+] Successfully converted PEM files to a Java keyStore.\e[39m"
echo
echo -e "\e[32m[+] Validating...\e[39m"
echo
keytool -list -keystore $out_file
echo
echo -e "\e[32m[+] Cleaning up...\e[39m"
echo
rm /tmp/ssl-all.pem
rm /tmp/cert.pkcs12
