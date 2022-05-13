# Container for SSH Tunnel

## Example

To mapping www.example.com:

```bash
ssh -4 -v -N -R 0.0.0.0:58080:www.example.com:80 u01@docker-host -p 30022
```

- `-4`: Avoid "Cannot assign requested address" in container;
- `-v`: Show detail log at ssh tunnel client;
- `@docker-host`: In ssh client container, `docker-host` is the address of host OS;
- `-p`: SSH Server port, depends on the port mapping of ssh server container.