#!/bin/sh

# Create the .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create symbolic link to our pre-commit hook
ln -sf ../../scripts/pre-commit .git/hooks/pre-commit

echo "Git hooks have been set up successfully!" 