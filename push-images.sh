#!/usr/bin/env bash

# Make sure we're in the current directory.
cd "$(dirname "$0")"

# Check arguments.
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <Deployer version>"
    exit
fi

# Set Deployer version.
deployer_version=$1
echo "Using Deployer v$deployer_version"
echo ""

# Define PHP versions.
php_versions=(7.4 8.0 8.1 8.2 8.3)

# Pushing images.
for php_version in "${php_versions[@]}"
do
    echo "Pushing image for PHP $php_version"
    docker push netzarbeiter/deployer:php-$php_version-deployer-$deployer_version
    docker push netzarbeiter/deployer:php-$php_version
    echo ""
done
