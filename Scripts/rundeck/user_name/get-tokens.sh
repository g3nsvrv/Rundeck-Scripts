#!/bin/bash
#############################################
# to run unatended mode, please comment the code above and uncomment the code below, and replace with your props
#############################################
# rundeckServer="http://localhost:4440"
# rundeckUser="admin"
# rundeckPass="admin"
#############################################
[[ -z "${rundeckServer:-}" ]] && { echo "Rundeck Server hostname:"; read -r rundeckServer; }
[[ -z "${rundeckUser:-}" ]]   && { echo -e "\nRundeck username:"; read -r rundeckUser; }
[[ -z "${rundeckPass:-}" ]]   && { echo -e "\nRundeck password:"; read -r -s rundeckPass; echo; }
#############################################
# Options Variables
#############################################
curlOptions="-s"
cookie="cookie"
apiVersion="19"
apiFormat="json"
#############################################

curl "$curlOptions" -X "POST" -d "j_username=$rundeckUser" -d "j_password=$rundeckPass" -c "$cookie" -b "$cookie" "$rundeckServer"/j_security_check

tokens="$(curl "$curlOptions" -X "GET" -H "Content-Type: application/$apiFormat" -H "Accept: application/$apiFormat" -c "$cookie" -b "$cookie" "$rundeckServer"/api/"$apiVersion"/tokens | jq .[].id | tr -d '"')"

for tokenID in $tokens
do
    curl "$curlOptions" -X "GET" -H "Content-Type: application/$apiFormat" -H "Accept: application/$apiFormat" -c "$cookie" -b "$cookie" "$rundeckServer"/api/"$apiVersion"/token/"$tokenID" | jq .
done

rm -f "$cookie"