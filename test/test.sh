#!/bin/bash

# load .env file
envFile=".env"
if [ -f "$envFile" ]; then
    echo "$envFile found."
    source $envFile
else 
    echo "$envFile not found."
fi

# wait for server
until $(curl --output /dev/null --silent --head --fail $LEMMY_DOMAIN); do
    printf '.'
    sleep 5
done

# test the frontend contains thge lemmy setup page
fe_response=$(curl -L -k -s  $LEMMY_DOMAIN)
fe_contains=$(echo $fe_response | grep -c "Lemmy Instance Setup")
if [ $fe_contains -eq 1 ]
then
    echo "✅ Frontend Returns Lemmy Instance Setup"
else
    echo $fe_response
    echo "❌ Frontend Does Not Return Lemmy Instance Setup"
    exit 1
fi

# test that nodeinfo returns correctly
nodeinfo_response=$(curl -L -k -s $LEMMY_DOMAIN/nodeinfo/2.0.json)
nodeinfo_contains=$(echo $nodeinfo_response | grep -c "\"software\":{\"name\":\"lemmy\",\"version\":")
if [ $nodeinfo_contains -eq 1 ]
then
    echo "✅ Node Info returns Lemmy Version"
else
    echo $nodeinfo_response
    echo "❌ Node Info does not return Lemmy Version"
    exit 1
fi

# register an admin user
register_result=$(curl -L -k -s $LEMMY_DOMAIN/api/v3/user/register -X POST \
    -H "Content-Type: application/json" -H 'Accept: */*' \
    --data-raw '{"username":"admin","password":"test_password49841981","password_verify":"test_password49841981","show_nsfw":true}')

echo $register_result


# sync test https://join-lemmy.org/docs/administration/first_steps.html#federation
api_response=$(curl -L -k -s -H 'Accept: application/activity+json' $LEMMY_DOMAIN/u/admin)
api_contains=$(echo $api_response | grep -c "\"outbox\": \"https://$LEMMY_DOMAIN/u/admin/outbox\",")
if [ $api_contains -eq 1 ]
then
    echo "✅ API returns ActivityPub User"
else
    echo $api_response
    echo "❌ API does not return ActivityPub User"
    exit 1
fi


# fe_response=$(curl -L -k -s $LEMMY_DOMAIN)
# fe_contains=$(echo $fe_response | grep -c "<title data-inferno-helmet=\"true\">New Site</title>")
# if [ $fe_contains -eq 1 ]
# then
#     echo "✅ Frontend Returns New Site"
# else
#     echo "❌ Frontend Does Not Return New Site"
#     exit 1
# fi



exit 0
