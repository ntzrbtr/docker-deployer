# Docker image for PHP deployment

Docker image built for the deployment of PHP projects (e.g. when using Gitlab CI); it is based on the [official PHP image](https://hub.docker.com/_/php) using Alpine Linux.

The image adds tools for deployment:
- [Composer](https://getcomposer.org/)
- [Deployer](https://deployer.org/)
- SSH client and tools
- `rsync`

Repository: https://github.com/ntzrbtr/docker-deployer

## Building images

Use the `build.sh` script to build and push the images. The script takes the Deployer version as an argument:

```bash
./build.sh 7.4.1
```
