build:
  docker build -t tidalbox .

run:
  docker run --replace -it  -v /run/user/1000/pipewire-0:/tmp/pipewire-0 \
    -e XDG_RUNTIME_DIR=/tmp --name tidalbox -p 3000:3000 --device /dev/snd/seq \
    tidalbox -s alkorejf