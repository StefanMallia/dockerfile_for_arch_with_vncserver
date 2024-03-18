if [ -z "$1" ]; then
    echo "Provide container name as argument"
    exit 1
fi

docker stop $1 && docker rm $1
docker run -td -p 5901:5901 --name $1 arch-linux-vnc\
    || \
    (\
        echo "Assigning random port."\
        && docker rm $1\
        && docker run -td -p :5901 --name $1 arch-linux-vnc\
        && docker ps -f name=$1\
    )
docker exec --user=arch --workdir=/home/arch -it $1 /bin/bash

