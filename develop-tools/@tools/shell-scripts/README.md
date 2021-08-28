# Scripts for DevOps



## Summary

### Commands

Command `dc-run` and `dc-start` worked as a docker-compose starter:

- `dc-run` - run docker compose then attach it's console(`exit` to terminate);
- `dc-start` - run docker compose as service in foreground(`Ctrl-C` to terminate); 

### Compose TYPE and folder name

Use `dc-run` and `dc-start` to handle two different types of compose file:

- `tools` - Use `dc-run` command to start, MUST be contained within folder `@compose-tools`; 
- `services` - Use `dc-start` command to start, with folder name `@compose-services`;



## Setup

### Add to PATH

```bash
# Add to ~/.bashrc
export PATH=$PATH:/home/***/devops-dockerfiles/develop-tools/@tools/shell-scripts
```



## Usage

### Command line arguments

`$1`: the compose name(docker-compose yml file's name without 'yml' extension);



**NOTE**: Run  `dc-run` or `dc-start` without arguments should print the usage information.



### Use variables in compose file

There are variables can be used in compose file:

- `COMPOSE_DIR`:

  - Directory of the compose YML file;
  - You can use `${COMPOSE_DIR}` to define volume relative to compose file

- `RUNTIME_DIR`: 
  
  - Directory to store runtime data;
  - Typically, we can define `volumes` based on the variables, to store configuration files or program's data in it; 
  - The actual value of`$RUNTIME_DIR` is in  compose file's directory, as the subdirectory with `POSITION_ID`( a string calculated from `$PWD` running   `dc-run` or `dc-start`) .
  
- `PORT1`/`PORT2`/`PORT3`: 
  - Auto-detected free ports for container running;
  - Mapping `ports` to `PORT1`/`PORT2`/`PORT3` should avoid port conflict when  running several containers at same time;
  - The first values of these ports is `8080`/`18080`/`28080` .



See [../../@demos/010-nodejs/@compose-services/demo-nodejs.yml](../../@demos/010-nodejs/@compose-services/demo-nodejs.yml) for example.



## Configuration

### Configure ${DEVOPS_COMPOSE_PATH}

Environment variable `DEVOPS_COMPOSE_PATH` used to setup the search path list for compose files(`@${COMPOSE_TYPE}/*.yml`), `:` to split paths;

**NOTE 1**:

- If undefined, default value is `./@${COMPOSE_TYPE}:$HOME/.platbase-devops-docker/@${COMPOSE_TYPE}` ( `COMPOSE_TYPE`: `compose-tools`  or `compose-services`);

**NOTE 2**:

- If `$1`==**`-`** , means the **`PWD`** mode: <u>1)</u>Find the first `*.yml` file; <u>2)</u>`DEVOPS_COMPOSE_PATH`=`.` .

