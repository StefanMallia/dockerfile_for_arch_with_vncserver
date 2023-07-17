docker build --file base.Dockerfile --build-arg archpassword=$1 -t arch-linux-base .
docker build --file vnc.Dockerfile  --build-arg archpassword=$1 --build-arg  vncpassword=$2 -t arch-linux-vnc .
