#!/bin/sh -l

# Run Replexica CLI to localize missing strings
npx replexica@latest localize
# Commit the changes into the current branch
git config --global --add safe.directory $PWD
git config --global user.name "Replexica"
git config --global user.email "support@replexica.com"
git add .
if git diff --staged --quiet; then
  echo "::notice::Replexica has not found any missing translations"
else
  git commit -m "feat: add missing translations [skip ci]"
  # Pull the latest changes from the remote repository
  git pull --rebase
  git push
  # retrieve the last commit hash
  COMMIT_HASH=$(git rev-parse HEAD)
  # build a github url to the commit
  COMMIT_URL="https://github.com/replexica/replexica/commit/$COMMIT_HASH"
  # output the commit url to the github actions announcements using ::notice::
  echo "::notice::Replexica has just added missing translations in the following commit: $COMMIT_URL"
fi