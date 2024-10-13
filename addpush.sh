#!/bin/bash

# Change to the desired directory
cd "/home/window/.config" || { echo "Failed to change directory. Exiting."; exit 1; }

# Define the git function
config() {
    /usr/bin/git --git-dir="$HOME/dotfiles/" --work-tree="$HOME" "$@"
}

# Get the file or folder names from the command-line arguments
USER_INPUT="$*"
# Split the input into an array
IFS=' ' read -r -a items <<< "$USER_INPUT"

# Check how many arguments are passed
if [ "${#items[@]}" -eq 1 ]; then
    # Only one item is passed
    item="${items[0]}"

    # Check if the file or folder exists
    if [ -e "$item" ]; then
        # If it exists, add it to the Git repository
        config add "$item"
        config commit -m "Added $item to GitHub"
        config push
        echo "Successfully pushed '$item' to GitHub."
    else
        # If it does not exist, display an error message
        echo "Error: '$item' does not exist. Please check the name and try again."
        exit 1
    fi
else
    # Multiple items are passed
    for item in "${items[@]}"; do
        # Check if the file or folder exists
        if [ -e "$item" ]; then
            # If it exists, add it to the Git repository
            config add "$item"
            echo "'$item' has been added to Git."
        else
            # If it does not exist, display an error message
            echo "Error: '$item' does not exist. Please check the name and try again."
            exit 1
        fi
    done

    # Commit and push all added files
    config commit -m "Added multiple files to GitHub"
    config push
    echo "All files have been successfully pushed to GitHub."
fi

