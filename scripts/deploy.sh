#!/bin/bash
set -e # exit with nonzero exit code if anything fails
set -x

BASE_DIR="$(dirname $0)/.."
TARGET_DIR="$BASE_DIR/target"

DOMAIN="push-api-docs.logbk.net"

if [ ! -e $TARGET_DIR ]; then
  "$BASE_DIR/scripts/build.sh"
fi

# go to the out directory and create a *new* Git repo
cd "$TARGET_DIR"
echo "$DOMAIN" > CNAME
git init

# inside this git repo we'll pretend to be a new user
git config user.name "Circle CI"
git config user.email "admin-ghdev@i-mobile.co.jp"

# The first and only commit to this new Git repo contains all the
# files present with the commit message "Deploy to GitHub Pages".
git add .
git commit -m "Deploy to GitHub Pages [ci skip]"

# Add remote repository
git remote add origin "git@github.com:pLucky-Inc/logpush-api-docs.git"

# Force push from the current repo's master branch to the remote
# repo's gh-pages branch. (All previous history on the gh-pages branch
# will be lost, since we are overwriting it.)
git push --force --quiet origin master:gh-pages
