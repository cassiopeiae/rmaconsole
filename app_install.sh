#! /usr/bin/env bash

echo Please provide the following details on your lab environment.
echo
echo "What is the address of your Mantl Control Server?  "
echo "eg: control.mantl.internet.com"
read control_address
echo
echo "What is the username for your Mantl account?  "
read mantl_user
echo
echo "What is the password for your Mantl account?  "
read -s mantl_password
echo
echo "What is the your Docker Username?  "
read docker_username
echo
echo "What is the Lab Application Domain?  "
read mantl_domain
echo
echo "What is the client ID for OAuth2? "
read client_id
echo
echo "What is the client secret for OAuth2? "
read client_secret
echo


#export MANTL_CONTROL="$control_address"
#export MANTL_USER="$mantl_user"
#export MANTL_PASSWORD="$mantl_password"

#echo "Marathon API calls will be sent to: "
#echo "https://$MANTL_CONTROL:8080/"

cp sample-rmaconsole.json $docker_username-rmaconsole.json
sed -i "" -e "s/DOCKERUSER/$docker_username/g" $docker_username-rmaconsole.json
sed -i "" -e "s/CLIENTID/$client_id/g" $docker_username-rmaconsole.json
sed -i "" -e "s/CLIENTSECRET/$client_secret/g" $docker_username-rmaconsole.json

echo " "
echo "***************************************************"
echo "Installing the demoapp as  imapex/rmaconsole"
curl -k -X POST -u $mantl_user:$mantl_password https://$control_address:8080/v2/apps \
-H "Content-type: application/json" \
-d @$docker_username-rmaconsole.json \
| python -m json.tool

echo "***************************************************"
echo

echo Installed

echo "Wait 2-3 minutes for the service to deploy. "
echo "Then you can visit your application at:  "
echo
echo "http://imapex-rmaconsole-.$mantl_domain/"
echo
echo
echo "You can also watch the progress from the GUI at: "
echo
echo "https://$control_address/marathon"
echo
