#!/bin/bash

# Set the number of days (change as needed)
DAYS_OLD=30

# Get the current date and format
CURRENT_DATE=$(date +%s)

# List branches that haven’t been committed to in the last X days
echo "Finding branches older than $DAYS_OLD days..."

# Loop through each branch and check the last commit date
for branch in $(git branch --format "%(refname:short)"); do
    # Get last commit timestamp of the branch
    LAST_COMMIT_DATE=$(git log -1 --format="%ct" "$branch")
    
    # Skip branches with no commits (rare case)
    if [ -z "$LAST_COMMIT_DATE" ]; then
        continue
    fi

    # Calculate branch age in days
    BRANCH_AGE=$(( (CURRENT_DATE - LAST_COMMIT_DATE) / 86400 ))

    # If the branch is older than the threshold, delete it
    if [ "$BRANCH_AGE" -gt "$DAYS_OLD" ]; then
        echo "⚠️  Branch '$branch' is $BRANCH_AGE days old. Deleting..."
        git branch -D "$branch"
    fi
done

echo "✅ Cleanup completed."

#####################
### REMOTE BRANCH ###
#####################

# Fetch latest remote branches
git fetch --prune

echo "Checking remote branches older than $DAYS_OLD days..."

# Get a list of remote branches
for branch in $(git for-each-ref --format '%(refname:short) %(committerdate:raw)' refs/remotes/origin/ | awk -v d="$DAYS_OLD" -v now="$CURRENT_DATE" '{if ((now - $2) / 86400 > d) print $1}'); do
    REMOTE_BRANCH=${branch#origin/}  # Remove 'origin/' prefix
    echo "⚠️  Deleting remote branch '$REMOTE_BRANCH'..."
    git push origin --delete "$REMOTE_BRANCH"
done

echo "✅ Remote branch cleanup completed."
