#!/usr/bin/env bash

#############################################
# to run unattended mode, please comment the code above and uncomment the code below, and replace with your props
#############################################
rundeckServer="RD_URL"
rundeckUser="admin"
rundeckPass="admin"
#############################################
# Options Variables
#############################################
curlOptions="-s"
cookie="cookie"
waitTime="10"
#############################################

# Loop until a "pong" response is received
while true; do
  # Authenticate and get a session cookie
  curl "$curlOptions" -X "POST" -d "j_username=$rundeckUser" -d "j_password=$rundeckPass" -c "$cookie" -b "$cookie" "$rundeckServer/j_security_check" > /dev/null

  # Fetch the response
  response=$(curl "$curlOptions" -X "GET" -H "Content-Type: text/plain" -H "Accept: text/plain" -c "$cookie" -b "$cookie" "$rundeckServer/api/25/metrics/ping")

  # Check if the response is "pong"
  if [ "$response" == "pong" ]; then
    echo "Received 'pong' response."
    break
  else
    echo "Waiting for 'pong' response..."
  fi

  # Wait for a few seconds before retrying
  sleep "$waitTime"
done

curl "$curlOptions" -X "POST" -d "j_username=$rundeckUser" -d "j_password=$rundeckPass" -c "$cookie" -b "$cookie" "$rundeckServer/j_security_check" > /dev/null

# Fetch Runners
response=$(curl "$curlOptions" -X "GET" -H "Content-Type: application/json" -H "Accept: application/json" -c "$cookie" -b "$cookie" "$rundeckServer/api/41/runnerManagement/runners")

# Extract the runner ID of "Default Runner" if it exists
runner_id=$(echo "$response" | jq -r '.runners[] | select(.name == "Default Runner") | .id')

if [ -n "$runner_id" ]; then
  echo "Runner 'Default Runner' exists with ID: $runner_id"
else
  echo "Runner 'Default Runner' not found. Creating the runner..."

  # Create the runner "Default Runner"
  response=$(curl "$curlOptions" -X "POST" -H "Content-Type: application/json" -H "Accept: application/json" -c "$cookie" -b "$cookie" "$rundeckServer/api/42/runnerManagement/runners" --data '
  {
    "name": "Default Runner",
    "description": "Test Runner for this environment",
    "assignedProjects": {
    },
    "tagNames": "runner, docker, linux",
    "replicaType": "ephemeral"
  }
  ')

  # Extract the ID of the newly created runner
  runner_id=$(echo "$response" | jq -r '.runnerId')
  echo "Created new 'Default Runner' with ID: $runner_id"
fi

# Use the runner_id to regenerate credentials
echo "Regenerating credentials for Runner with ID: $runner_id"

credentials_response=$(curl "$curlOptions" -X "POST" -H "Content-Type: application/json" -H "Accept: application/json" -c "$cookie" -b "$cookie" "$rundeckServer/api/42/runnerManagement/runner/$runner_id/regenerateCreds")

# Extract and print the token from the credentials response
runner_token=$(echo "$credentials_response" | jq -r '.token')
download_token=$(echo "$credentials_response" | jq -r '.downloadTk')

echo "Runner authentication token: $runner_token"
echo "Runner package download token: $download_token"

# Clean up the cookie file
rm -f "$cookie"

# Start Runner
env \
  RUNNER_RUNDECK_CLIENT_ID="$runner_id" \
  RUNNER_RUNDECK_SERVER_TOKEN="$runner_token" \
  RUNNER_RUNDECK_SERVER_URL="$rundeckServer" \
  java \
  -Dcom.sun.management.jmxremote \
  -Dcom.sun.management.jmxremote.port=9010 \
  -Dcom.sun.management.jmxremote.local.only=false \
  -Dcom.sun.management.jmxremote.authenticate=false \
  -Dcom.sun.management.jmxremote.ssl=false \
  -Djava.rmi.server.hostname=$(hostname) \
  -jar /app/pd-runner.jar