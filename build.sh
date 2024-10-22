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

# Define function for building and pushing images.
function build_and_push_image {
    php_version=$1
    platform=$2
    suffix=$3

    echo "Building image for PHP $php_version on platform $platform"
    rm -rf $php_version && mkdir $php_version
    cp Dockerfile.template $php_version/Dockerfile
    sed -i '' "s/%PHP-VERSION%/$php_version/" $php_version/Dockerfile
    sed -i '' "s/%DEPLOYER-VERSION%/$deployer_version/" $php_version/Dockerfile
    docker build --platform $platform --file $php_version/Dockerfile -t netzarbeiter/deployer-$suffix:php-$php_version-deployer-$deployer_version -t netzarbeiter/deployer-$suffix:php-$php_version .
    echo ""

    echo "Pushing image for PHP $php_version on platform $platform"
    docker push netzarbeiter/deployer-$suffix:php-$php_version-deployer-$deployer_version
    docker push netzarbeiter/deployer-$suffix:php-$php_version
    echo ""
}

# Build and push images.
for php_version in "${php_versions[@]}"
do
    # Build and push platform-specific images.
    build_and_push_image $php_version linux/arm64 arm64
    build_and_push_image $php_version linux/amd64 amd64

    # Create and push multi-arch manifest.
    echo "Creating and pushing multi-arch manifest for PHP $php_version"
    docker manifest create netzarbeiter/deployer:php-$php_version-deployer-$deployer_version netzarbeiter/deployer-arm64:php-$php_version-deployer-$deployer_version netzarbeiter/deployer-amd64:php-$php_version-deployer-$deployer_version
    docker manifest push netzarbeiter/deployer:php-$php_version-deployer-$deployer_version
    docker manifest create netzarbeiter/deployer:php-$php_version netzarbeiter/deployer-arm64:php-$php_version netzarbeiter/deployer-amd64:php-$php_version
    docker manifest push netzarbeiter/deployer:php-$php_version
done
