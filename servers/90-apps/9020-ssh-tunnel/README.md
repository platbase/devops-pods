# Container for SSH Tunnel

## SSH Tunnel Basis

The topic SSH Command line (mapping to www.example.com) :

```bash
ssh -4 -v -N -R 0.0.0.0:58080:www.example.com:80 u01@docker-host -p 30022
```

- `-4`: Avoid "Cannot assign requested address" in container;
- `-v`: Show detail log at ssh tunnel client;
- `-N -R 0.0.0.0:58080:www.example.com:80 u01@docker-host -p 30022`:
  - `@docker-host`: In ssh client container, `docker-host` is the address of host OS;
  - `-p`: SSH Server port, depends on the port mapping of ssh server container.

## Server Configuration

Example: [./sshd-t-server/@compose-services/test-sshd-t-server.yml](./sshd-t-server/@compose-services/test-sshd-t-server.yml) .

- `U01_SSH_PWD`: The password of user "u01", client should connect server with this password.

## Client Configuration

Example: [./ssh-t-client/@compose-services/test-ssh-t-client.yml](./ssh-t-client/@compose-services/test-ssh-t-client.yml) , reference: [./ssh-t-client/resources/docker-init/etc/u01.d/00-start.sh](./ssh-t-client/resources/docker-init/etc/u01.d/00-start.sh) .

- `U01_SSH_PWD`: Same as the password of server;
- `U01_SSH_ARGS`: The arguments of `ssh` command;
  - **NOTE:** `ssh -4 -v ` is the build-in part of `ssh` command, they should not need include in `U01_SSH_ARGS` environment variable;
- `NET_DETECT_CMD`: The command to detect network status, if connection was broken detected,  `ssh` command should be retry;
- `NET_DETECT_SEC`: Interval time (in seconds) to detect network status. *optional, default 30 seconds*;
- `NET_CONFIRM_SEC`: Delay time (in seconds) to confirm network status. *optional, default 10 seconds*;

### About `NET_DETECT_CMD`

There some build-in functions (`detect*`) for `NET_DETECT_CMD` : `delectWithNetcat`, `detectWithWget`, ..., read  [./ssh-t-client/resources/docker-init/etc/u01.d/00-start.sh](./ssh-t-client/resources/docker-init/etc/u01.d/00-start.sh) for detail.

### About `ssh` command

- Reverse tunnel:
  
  ```ruby
  -N -R 0.0.0.0:${Server Listen Port}:${Forward Address}:${Forward Port} u01@${Server Address} -p ${Server SSH Port}
  ```
  
  1. `0.0.0.0`: In docker container, the remote address should be always `0.0.0.0` to be compatible with container's port mapping;
  2. `Server Listen Port`: The service port on SSH Server;
  3. `Forward Address`: The IP or DNS Address of target server;
  4. `Forward Port`: The network port  of target server;
  5. `Server Address`: The Address of SSH Server;
  6. `Server SSH Port`: The port of SSH Service;

- Socks proxy:
  
  ```ruby
  -D 0.0.0.0:${Proxy Port} -N u01@${Server Address} -p ${Server SSH Port}
  ```
  
  - `Proxy Port`: The socks proxy port

- ...

## Example and reference

### Export local git/sshd server with reverse tunnel

- `U01_SSH_ARGS`:
  
  ```ruby
  -R 0.0.0.0:7722:local-git-sshd:22 -o StreamLocalBindUnlink=yes -o ServerAliveInterval=10 -o ServerAliveCountMax=6 -N u01@example.com -p 57777
  ```
  
  - `-o StreamLocalBindUnlink=yes` - Specifies whether to remove an existing Unix-domain socket file for local or remote port forwarding before creating a new one.  It's useful to fix the random problem "Address already in use" of forwarded port.
  - `-o ServerAliveInterval=10 -o ServerAliveCountMax=6` - It's helpful to make connection keep alive.

- `NET_DETECT_CMD`:
  
  ```bash
  sshpass -p ${U01_SSH_PWD} \
          ssh -o ConnectTimeout=5 u01@example.com -p 57777 \
              "sshpass -p ****** ssh -o ConnectTimeout=5 u01@localhost -p 7722 'ls -al /git'"
  ```

- OR `NET_DETECT_CMD` (reference: https://www.golinuxcloud.com/test-ssh-connection/ ):
  
  ```bash
  sshpass -p ${U01_SSH_PWD} \
          ssh -o ConnectTimeout=5 u01@example.com -p 57777 \
              "echo *quit | telnet -e* localhost 7722 2>/dev/null | egrep -qi 'Connected to localhost.'"
  ```

## END