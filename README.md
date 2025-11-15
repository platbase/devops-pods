# devops-pods

The Dockerfiles for development, testing and deployment.

## Abstract

- `devpods` - for development
  - `00-base` - The basic container image, with sshd, rinetd, crond, atd, nginx, dockerd installed
  - `30-frontend-stack` - The container image for nodejs and frontend development environment
  - `40-java-stack` - The container image for java development environment
  - `90-mysql-server` - The container image with MySQL Database Server
- `servers` - TODO - server environments, to be port to podman style

## Troubleshoot

### dockerd
After `bookworm-20250610`, Running `dockerd` in `00-base` container has the following limits:
1. `Ubuntu 22.04.5 LTS` - Can't support `"storage-driver": "overlay2"`:
   - The reason is `userxattr`: an overlayfs mount option (Linux ≥5.11) that allows unprivileged users to read/write extended attributes.
   - Older kernels reject it with -EINVAL; newer Docker/containerd enable it by default, so systems with kernel <5.11 fail to mount overlayfs and Docker reports “driver not supported”.
   - Or kernel compile-time switch `CONFIG_OVERLAY_FS_USERXATTR` is disabled (common in some vendor kernels), the file `/sys/module/overlay/parameters/userxattr` is missing and any mount request with userxattr returns -EINVAL, even on kernel 6.x.
   - **`[Solution]`**: start container with `-e DOCKER_DAEMON_ARGS="--storage-driver=vfs"`
      ```bash
      podman run --privileged -it --rm \
          -e DOCKER_DAEMON_ARGS="--storage-driver=vfs" --name test-dev-base-dind \
          bizobj-container.net/pods/dev.base:bookworm-20251103 --dockerd -- iostat 10
      ``` 
2. `Ubuntu 20.04.6 LTS` - Error like:
   ```
   docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: unable to apply cgroup configuration: mkdir /sys/fs/cgroup/cpuset/docker/32ca877a452f378acc77a6183b42cc0ac806483a390be3cb482b3798677ae752: permission denied
   ```