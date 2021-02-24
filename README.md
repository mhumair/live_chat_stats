# MANUALLY GETTING THE STATS

I think some of you might not be lazy enough to set up a better regex for this. The stats file is well commented for better understanding.

## GET THE FILE
How to generate personal_access_token : https://cutt.ly/2kcA6eB

`wget -O chatstats.sh --no-check-certificate -q https://raw.githubusercontent.com/mhumair/live_chat_stats/master/final_chat_stats.sh &&
grep -lr 'p_a_t' | xargs sed -i 's|p_a_t|<replace_with_your_personal_access_token>|g' &&
chmod +x ./chatstats.sh`


## GET THE STATS 

`./chatstats.sh <your_email>`

