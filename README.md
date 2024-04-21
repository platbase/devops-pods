# devops-pods

The Dockerfiles for development, testing and deployment.

## Abstract

- `devpods` - for development
  - `00-base` - The basic container image
  - `30-frontend-stack` - The container image for nodejs and frontend development environment
  - `40-java-stack` - The container image for java development environment
  - `90-mysql-server` - The container image with MySQL Database Server
- `servers` - TODO - server environments, to be port to podman style
