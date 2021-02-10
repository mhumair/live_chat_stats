#!/bin/bash

# REQUIRED DATA TO MAKE THE CURL REQUEST

# get the current system date . update the value(format : yyyy:mm:yy) here in this format to get custom interval reports
DATE_FROM=$(date +"%Y-%m-%d") 
DATE_TO=$(date +"%Y-%m-%d")
# ************************************************************************************
# personal access token (pat). how to generate : https://cutt.ly/2kcA6eB
PAT=hamza.haider@cloudways.com:dal:efMFzOxnphaorknghG94e9u94hs
# ************************************************************************************

# gets the email from the commandline arguments.
AGENT_EMAIL=$1
# ************************************************************************************

# setting up the curl requests to get the data
CURL_URL_AVG_CHAT_DURATION="https://api.livechatinc.com/reports/chats/duration?date_from=$DATE_FROM&date_to=$DATE_TO&agent=$AGENT_EMAIL&group_by=month"

CURL_URL_AVG_RESPONSE_TIME="https://api.livechatinc.com/reports/chats/response_time?date_from=$DATE_FROM&date_to=$DATE_TO&agent=$AGENT_EMAIL&group_by=month"

DATA_ONE=$(curl -s $CURL_URL_AVG_CHAT_DURATION -u $PAT -H X-API-Version:2)

CHAT_COUNT=$(echo $DATA_ONE|grep -oP '(?<=count":)[0-9]+')
if [[ $CHAT_COUNT -gt 0 ]]
then
DATA_TWO=$(curl -s $CURL_URL_AVG_RESPONSE_TIME -u $PAT -H X-API-Version:2)

# ************************************************************************************

# extracting required text from the json response
let AVG_DURATION_RAW=$(echo $DATA_ONE|grep -oP '(?<=seconds":)[0-9]+')

let AVG_RESPONSE_RAW=$(echo $DATA_TWO|grep -oP '(?<=seconds":)[0-9]+')
# ************************************************************************************
#echo $AVG_RESPONSE_RAW
#echo $AVG_DURATION_RAW
# conversion from seconds to minutes were applicable
if [[ $AVG_DURATION_RAW -gt 60 ]]
then
  AVG_DURATION_FINAL=$(echo "scale=2; (${AVG_DURATION_RAW=}/60)" | bc)
else
  let AVG_DURATION_FINAL=$AVG_DURATION_RAW
fi

if [[ $AVG_RESPONSE_RAW -gt 60 ]]
then
  AVG_RESPONSE_FINAL=$(echo "scale=2; (${AVG_RESPONSE_RAW=}/60)-.10" | bc)
else
  let AVG_RESPONSE_FINAL=$AVG_RESPONSE_RAW
fi
# ************************************************************************************

# I"LL LET YOU GUESS WHAT's HAPPENING HERE
#CHAT_COUNT=$(echo $DATA_ONE|grep -oP '(?<=count":)[0-9]+')
#echo "{\""AGENT_EMAIL"\":\""$1"\",\""CHAT_COUNT"\":\""$CHAT_COUNT"\",\""AVERAGE_CHAT_DURATION"\":\""$AVG_DURATION_FINAL"\",\""AVERAGE_RESPONSE_TIME"\":\""$AVG_RESPONSE_FINAL\""}"

echo "{\""text\"":\""$(echo "*AGENT EMAIL* :$1 \n *CHAT COUNT* : $CHAT_COUNT \n *AVERAGE CHAT DURATION* : $AVG_DURATION_FINAL minutes \n *AVERAGE RESPONSE TIME* : $AVG_RESPONSE_FINAL seconds")"\"}"
#curl -i -X POST -H 'Content-type: text/xml' --data-binary "@./stats.txt" https://hooks.slack.com/services/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
else
echo "{\""text\"":\""ENGINEER IS PROBABLY ON LEAVE TODAY\""}"
fi
