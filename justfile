build:
  docker build -t tidalbox .

run SESSION:
  docker run --replace -it \
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 -e XDG_RUNTIME_DIR=/tmp \
    --device /dev/snd/seq \
    -v samples:/samples \
    -p 3000:3000 \
    --name tidalbox tidalbox {{SESSION}}

vis SESSION ADDRESS="host.containers.internal" PORT="50503":
  docker run --replace -it \
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 -e XDG_RUNTIME_DIR=/tmp \
    --device /dev/snd/seq \
    -e VISUALIZER=true \
    -e VISUALIZER_ADDRESS={{ADDRESS}} \
    -e VISUALIZER_PORT={{PORT}} \
    --net=slirp4netns \
    -v samples:/samples \
    -p 3000:3000 \
    --name tidalbox tidalbox {{SESSION}}

hydra SESSION:
  docker run --replace -it \
    -v /run/user/1000/pipewire-0:/tmp/pipewire-0 -e XDG_RUNTIME_DIR=/tmp \
    --device /dev/snd/seq \
    -e HYDRA_OSC=true \
    -e VISUALIZER=true \
    -e VISUALIZER_ADDRESS=localhost \
    -e VISUALIZER_PORT=41234 \
    -v samples:/samples \
    -p 3000:3000 \
    -p 8080:8080 \
    --name tidalbox tidalbox {{SESSION}}
