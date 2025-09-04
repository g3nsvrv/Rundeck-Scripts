#!/bin/bash
#############################################
echo "Rundeck Server hostname:"; read -r rundeckServer
echo -e "\nRundeck username:"; read -r rundeckUser
echo -e "\nRundeck password:"; read -r rundeckPass
#############################################
# to run unatended mode, please comment the code above and uncomment the code below, and replace with your props
#############################################
# rundeckServer="http://localhost:4440"
# rundeckUser="admin"
# rundeckPass="admin"
#############################################
# Options Variables
#############################################
curlOptions="-s"
cookie="cookie"
#############################################
rundeckApiVersion="35"
rundeckApiFormat="json"
rundeckJobFormat="yaml"
#############################################

curl "$curlOptions" -X "POST" -d "j_username=$rundeckUser" -d "j_password=$rundeckPass" -c "$cookie" -b "$cookie" "$rundeckServer"/j_security_check

curl "$curlOptions" -X "GET" -b "$cookie" -c "$cookie" "$rundeckServer"/api/"$rundeckApiVersion"/metrics/metrics | jq .

curl "$curlOptions" -X "GET" -b "$cookie" -c "$cookie" "$rundeckServer"/api/"$rundeckApiVersion"/system/info | jq .


rm -f "$cookie"
