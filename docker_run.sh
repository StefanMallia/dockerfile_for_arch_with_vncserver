PORT=5901

print_usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -n, --container-name  Specify the container name."
  echo "  -p, --port            Specify the port number."
  echo "  -h, --help            Display this help message and exit."
}

options_passed=0
while true; do
  case "$1" in
    -n | --container-name ) CONTAINER_NAME=$2; shift 2 ;;
    -p | --port ) PORT=$2; shift 2 ;;
    -h | --help ) print_usage; exit 0 ;;
    -- ) shift; break ;;
    * ) if [ $options_passed == 1 ]; then break; fi; print_usage; exit 1 ;;
  esac
  options_passed=1
done


docker stop $CONTAINER_NAME && docker rm $CONTAINER_NAME
docker run\
    --volume $PWD/docker_volume_mount:/home/arch/Base/\
    --volume $PWD/hists_and_configs/.bash_history:/home/arch/.bash_history\
    --volume $PWD/hists_and_configs/.bashrc:/home/arch/.bashrc\
    -td -p $PORT:5901 --name $CONTAINER_NAME arch-linux-vnc\

docker exec --user=arch --workdir=/home/arch -it $CONTAINER_NAME /bin/bash

