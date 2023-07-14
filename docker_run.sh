docker stop arch-vnc-container && docker rm arch-vnc-container
docker run -td -p 5901:5901 --name arch-vnc-container arch-linux-vnc
#docker exec -it arch-vnc-container /bin/bash

