#!/bin/bash
# Simple script to request the gitlab repo and clone it into the codespace workspace
set -e

USERNAME=${GITLAB_USERNAME:-"user"}
GITLAB_HOST=${GITLAB_HOST:-"gitlab.sofa.dev"}

if [ -z "$GITLAB_TOKEN" ]
then
    echo "You did not define a secret for your gitlab token (GITLAB_TOKEN). Check the README to speed things up in the future."
    read -p "Enter your Gitlab token: " GITLAB_TOKEN
    echo
fi

shopt -s nocasematch
while [ -z "$GITLAB_URL" ]
do
    read -p "Enter your Gitlab repo: " GITLAB_REPO
    echo
    REGEXP="^https://${GITLAB_HOST}/([^.]*)(.git)?$"
    if [[ $GITLAB_REPO =~ $REGEXP ]]
    then
        GITLAB_URL="https://${GITLAB_HOST}/${BASH_REMATCH[1]}"
        GITLAB_URL_TOKEN="https://$USERNAME:$GITLAB_TOKEN@${GITLAB_HOST}/${BASH_REMATCH[1]}"
        break
    fi
    if [[ $GITLAB_REPO =~ ^(.*)/(.*)$ ]]
    then
        GITLAB_URL="https://${GITLAB_HOST}/$GITLAB_REPO"
        GITLAB_URL_TOKEN="https://$USERNAME:$GITLAB_TOKEN@${GITLAB_HOST}/$GITLAB_REPO"
        break
    fi

    echo "Invalid Gitlab repo. It should be either the URL of the repository or a string like this: (group/repo_name)"
    echo "Please try again..."
    echo
done

echo "Cloning repository $GITLAB_URL"
if git clone $GITLAB_URL_TOKEN . ;
then
    echo "Repository cloned successfully"
    echo "Your codespace name is: $CODESPACE_NAME. You can change it on github.com"
    echo "Now, you should rebuild your codespace image"
else
    echo "Error cloning repository" 
    echo "Check your Gitlab token and repo URL"
    exit 1
fi