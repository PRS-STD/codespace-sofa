# Gitlab bridge codespace
GITLAB_TOKEN

Welcome to your new Codespace! A prompt will ask for the location of your SOFA repository. You should have defined a SECRET in your GitHub profile with the name GITLAB_TOKEN and the value of your personal access token (Profile > Settings > Codespaces > Codespaces secrets > New secret) 

If you don't have a Gitlab token... This token should have the following scopes:

Select repositories





#########################################

- Create a new codespace from the [codespace-sofa template](). Open your github account, go to https://github.com/codespaces and click on the button "Use this template" on the blank template (it will be used only temporarily).

This will open a VS Code instance in your browser and instantiate a generic dev container in Github codespaces. Now, you will need to connect it to your repository:
```bash
git clone https://username:apitoken@gitlab.sofa.dev/atlas/atlas_meeting_generator.git .
```

Where `username` is your user in SOFA and `apitoken` is a personal access token with the scopes `read_repository` and `write_repository`. You can create a personal access token in your gitlab account settings. Mind the '.' at the end of the line to make sure that your repository is cloned in the current directory rather than in a subdirectory.

Finally, ensure that your git user name and email are set correctly. You can do this with the following commands:
```bash
git config user.name "Your Name"
git config user.email "your ECB email address"
```

Since as part of the git clone command you would have downloaded the `.devcontainer` directory, you will need to rebuild your codespace. It is very likely that VS Code detects this situation and asks you to do it. Otherwise, you can do it via the VS Code command *"Codespaces: Rebuild Container"*.

With this, you will have access to a development environment that includes all the necessary tools to do your work.