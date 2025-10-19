#!/bin/bash

# GITLAB_* and GITHUB_* Prefix env vars export in $HOME/.zshenv

if pwd | grep -q "gitlab"; then
  USER_MAIL=$GITLAB_USER_MAIL
  USER_EMAIL=$GITLAB_USER_EMAIL
elif pwd | grep -q "github"; then
  USER_MAIL=$GITHUB_USER_MAIL
  USER_EMAIL=$GITHUB_USER_EMAIL
else
  echo "Path not exists"
fi

setLocalConfig() {
  git config --local user.name "$USER_NAME"
  git config --local  user.mail "$USER_MAIL"
  git config --local  user.email "$USER_EMAIL"
  git config --local pull.rebase "true"
}

if git rev-parse --is-inside-work-tree > /dev/null 2>&1; then
    echo "✅ This directory is inside a Git repository."
else
    echo "❌ This directory is NOT a Git repository."
    echo "initilizing git"
    git init --initial-branch=main
    setLocalConfig
fi

