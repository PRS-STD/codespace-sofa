#!/bin/bash
# Simple script to request the gitlab repo and clone it into the codespace workspace
set -e

# It seems the user is not really used by gitlab, but it is required by the git clone command
USER=${GITHUB_USER:-"user"}

# The gitlab host is established as an environment variable in the .devcontainer
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
        GITLAB_URL_TOKEN="https://$USER:$GITLAB_TOKEN@${GITLAB_HOST}/${BASH_REMATCH[1]}"
        break
    fi
    if [[ $GITLAB_REPO =~ ^(.*)/(.*)$ ]]
    then
        GITLAB_URL="https://${GITLAB_HOST}/$GITLAB_REPO"
        GITLAB_URL_TOKEN="https://$USER:$GITLAB_TOKEN@${GITLAB_HOST}/$GITLAB_REPO"
        break
    fi

    echo "Invalid Gitlab repo. It should be either the URL of the repository or a string like this: (group/repo_name)"
    echo "Please try again..."
    echo
done

echo "Cloning repository $GITLAB_URL"
if git clone $GITLAB_URL_TOKEN . ;
then
    git config --global user.name "${ECB_NAME:-GIT_COMMITTER_NAME}"
    git config --global user.email "${ECB_EMAIL:-GIT_COMMITTER_EMAIL}"
    GIT_AUTHOR_NAME=$(git config user.name)
    GIT_AUTHOR_EMAIL=$(git config user.email)
    echo
    echo "Repository cloned successfully"
    echo "Your codespace name is: $CODESPACE_NAME. You can change it on github.com"
    echo "Now, you should rebuild your codespace image (CTRL+SHIFT+P -> Codespaces: Rebuild Container)"
    echo
    echo "Your name and email address will appear in commits like this:"
    echo "Author: $GIT_AUTHOR_NAME <$GIT_AUTHOR_EMAIL>"
    echo "You can change it with the following commands:"
    echo "git config --global user.name \"Your Name\""
    echo "git config --global user.email \"Your email\""
else
    echo "Error cloning repository: git clone $GITLAB_URL_TOKEN ." 
    echo "Double check the instructions at https://github.com/PRS-STD/codespace-sofa#readme"
    exit 1
fi