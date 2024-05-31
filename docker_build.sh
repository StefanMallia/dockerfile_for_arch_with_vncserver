print_usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Options:"
  echo "  -n, --arch-password  Specify the password for the arch user."
  echo "  -p, --vnc-password   Specify the password used to connect to the vnc server."
  echo "  -h, --help            Display this help message and exit."
}

options_passed=0
while true; do
  case "$1" in
    -n | --arch-password ) ARCH_PASSWORD=$2; shift 2 ;;
    -p | --vnc-password ) VNC_PASSWORD=$2; shift 2 ;;
    -h | --help ) print_usage; exit 0 ;;
    -- ) shift; break ;;
    * ) if [ $options_passed == 1 ]; then break; fi; print_usage; exit 1 ;;
  esac
  options_passed=1
done


docker build --file base.Dockerfile --build-arg archpassword=$ARCH_PASSWORD -t arch-linux-base .
docker build --file vnc.Dockerfile  --build-arg  vncpassword=$VNC_PASSWORD -t arch-linux-vnc .
