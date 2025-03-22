#!/bin/bash
set -e
set -u

# Change password of 'root'
sudo bash -c "echo \"root:${SET_ROOT_PASS}\" | chpasswd"
echo ">>> Password of 'root' is reset."

f_usage(){
    echo -e "\n[Help]
    Options and arguments:
        --sshd   : Start sshd service
        --rinetd : Start rinetd service
        --crond  : Start crond service
        --atd    : Start atd service
        --nginx  : Start nginx service
        --dockerd: Start docker (DinD)
        (tail):   Command to run
    
    For example:
        ./entry.base.sh --sshd echo "Hello World!"
    Or use "--" to separate options in command:
        ./entry.base.sh --rinetd -- sleep --help
    "
}

echo -e "\nBegin to parse CMD ..."
# Prepare to process arguments ...
ORIG_CMD="$*"
WITH_sshd=0
WITH_rinetd=0
WITH_crond=0
WITH_atd=0
WITH_nginx=0
WITH_dockerd=0
# Getopt: parse arguments
ARGS=$(getopt -o h --long help,sshd,rinetd,crond,atd,nginx,dockerd -- "$@")
eval set -- "${ARGS}"
while true
do
    case "$1" in
        -h|--help)
            f_usage
            exit 0
            ;;
        --sshd)
            echo "[--sshd]: Should start sshd .";
            WITH_sshd=1
            shift
            ;;
        --rinetd)
            echo "[--rinetd]: Should start rinetd .";
            WITH_rinetd=1
            shift
            ;;
        --crond)
            echo "[--crond]: Should start crond .";
            WITH_crond=1
            shift
            ;;
        --atd)
            echo "[--atd]: Should start atd .";
            WITH_atd=1
            shift
            ;;
        --nginx)
            echo "[--nginx]: Should start nginx .";
            WITH_nginx=1
            shift
            ;;
        --dockerd)
            echo "[--dockerd]: Should start docker(DinD) .";
            WITH_dockerd=1
            shift
            ;;
        --)
            shift
            echo "[--]: Should run command: [$@]";
            break
            ;;
        *)
            echo "Internal error: CMD = [${ORIG_CMD}]"
            exit 1
            ;;
    esac
done

echo -e "\nBegin to process CMD ..."

if [ $WITH_sshd == 1 ]; then
    echo ">>> Private key files regularization ..."
    sudo chown -Rv root:root /etc/ssh/
    sudo chmod -v 600 /etc/ssh/ssh_host_*_key
    echo ">>> Starting sshd ..."
    sudo service ssh start
    sudo service ssh status
fi

if [ $WITH_rinetd == 1 ]; then
    echo ">>> Starting rinetd ..."
    sudo service rinetd start
    sudo service rinetd status
fi

if [ $WITH_crond == 1 ]; then
    echo ">>> Starting crond ..."
    sudo service cron start
    sudo service cron status
fi

if [ $WITH_atd == 1 ]; then
    echo ">>> Starting atd ..."
    sudo service atd start
    sudo service atd status
fi

if [ $WITH_nginx == 1 ]; then
    echo ">>> Starting nginx ..."
    sudo service nginx start
    sudo service nginx status
fi

if [ $WITH_dockerd == 1 ]; then
    echo ">>> Starting dockerd(DinD) ..."
    sudo sh -c "nohup dockerd --host=unix:///var/run/docker.sock > /var/log/dockerd.log 2>&1 &"
    ps -ef | grep docker
fi

if [ -z "$*" ];then
    echo ">>> No command, exit."
else
    echo ">>> Starting command [$@] ..."
    exec "$@"
fi
