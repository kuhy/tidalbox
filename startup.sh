#!/bin/bash

# Run Flok
flok-web &

# Run SuperCollider REPL
flok-repl -s "$1" -t sclang --extra '{ "sclang": "pw-jack sclang" }' 2>&1 &

# Run Tidal REPL
flok-repl -s "$1" -t tidal --extra '{ "bootScript": "/root/.config/tidal/startup.hs" }' 2>&1 &

# Run hydra-osc
if [[ "$HYDRA_OSC" == 'true' ]]; then
    node /hydra-osc/hydra-osc.js 2>&1 &
fi

# Run Bash
/bin/bash
