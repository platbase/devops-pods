# devops-pods

The Dockerfiles for development, testing and deployment.

## Abstract

- `devpods` - for development
  - `00-base` - The basic container image, with sshd, rinetd, crond, atd, nginx, dockerd/podman installed
  - `30-frontend-stack` - The container image for nodejs and frontend development environment
  - `40-java-stack` - The container image for java development environment
  - `90-mysql-server` - The container image with MySQL Database Server
- `servers` - TODO - server environments, to be port to podman style

## Notes

### podman
- Has a configutated `/etc/containers/storage.conf`, for running podman with root, using `fuse-overlayfs` to support `driver="overlay"`, and define the `runroot`(MUST set if  was specified) and `graphroot`.

## Troubleshoot

### dockerd
The The basic container image(`00-base`) installed dockerd inside. After `bookworm-20250610`, Running `dockerd` in `00-base` container has the following limits:
1. `Ubuntu 22.04.5 LTS`(`Linux 6.8.0-86-generic (c20bc164f7d6)`) - Can't support `"storage-driver": "overlay2"`:
   - The reason is `userxattr`: an overlayfs mount option (Linux ≥5.11) that allows unprivileged users to read/write extended attributes.
   - Older kernels reject it with -EINVAL; newer Docker/containerd enable it by default, so systems with kernel <5.11 fail to mount overlayfs and Docker reports “driver not supported”.
   - Or kernel compile-time switch `CONFIG_OVERLAY_FS_USERXATTR` is disabled (common in some vendor kernels), the file `/sys/module/overlay/parameters/userxattr` is missing and any mount request with userxattr returns -EINVAL, even on kernel 6.x.
   - **`[Solution]`**: start container with `-e DOCKER_DAEMON_ARGS="--storage-driver=vfs"`
      ```bash
      podman run --privileged -it --rm \
          -e DOCKER_DAEMON_ARGS="--storage-driver=vfs" --name test-dev-base-dind \
          bizobj-container.net/pods/dev.base:latest --dockerd -- iostat 10
      ``` 
2. `Ubuntu 20.04.6 LTS`(`Linux 5.4.0-202-generic (cca1e631b957)`)- Error like:
   ```
   docker: Error response from daemon: failed to create task for container: failed to create shim task: OCI runtime create failed: runc create failed: unable to start container process: unable to apply cgroup configuration: mkdir /sys/fs/cgroup/cpuset/docker/32ca877a452f378acc77a6183b42cc0ac806483a390be3cb482b3798677ae752: permission denied
   ```

### podman
The The basic container image(`00-base`) installed podman inside, rootless mode:
1. Run properly with `cgroups-v2`, and `--privileged` mode, tested in `Ubuntu 22.04.5 LTS`(`Linux 6.8.0-86-generic (c20bc164f7d6)`).
2. Error with `cgroups-v1`, the topic error info like:
   ```
   ...
   WARN[0000] Using cgroups-v1 which is deprecated in favor of cgroups-v2 with Podman v5 and will be removed in a future version. Set environment variable `PODMAN_IGNORE_CGROUPSV1_WARNING` to hide this warning. 
   ...
   Error: creating cgroup for memory: mkdir /sys/fs/cgroup/memory/libpod_parent: permission denied
   ...
   ```