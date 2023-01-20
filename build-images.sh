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
php_versions=(7.4 8.0 8.1 8.2)

# Build images.
for php_version in "${php_versions[@]}"
do
    echo "Building image for PHP $php_version"
    rm -rf $php_version && mkdir $php_version
    cp Dockerfile.template $php_version/Dockerfile
    sed -i '' "s/%PHP-VERSION%/$php_version/" $php_version/Dockerfile
    sed -i '' "s/%DEPLOYER-VERSION%/$deployer_version/" $php_version/Dockerfile
    docker build --file $php_version/Dockerfile -t ntzrbtr/deployer:php-$php_version-deployer-$deployer_version -t ntzrbtr/deployer:php-$php_version .
    echo ""
done
