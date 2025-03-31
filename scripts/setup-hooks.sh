#!/bin/sh

which pre-commit

if [ $? -ne 0 ]; then
    echo "pre-commit is not installed. Please install it using 'brew install pre-commit'"
    exit 1
fi

# Create the .git/hooks directory if it doesn't exist
mkdir -p .git/hooks

# Create symbolic link to our pre-commit hook
ln -sf ../../scripts/pre-commit .git/hooks/pre-commit

# Install the pre-commit hooks
pre-commit install

echo "Git hooks have been set up successfully!" 