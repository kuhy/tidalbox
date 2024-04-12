#!/bin/bash

# Run SuperCollider
pw-jack sclang -D &

# Run Flok
flok-web &

# Run flok-repl
flok-repl -t tidal --extra '{ "bootScript": "/root/.config/tidal/startup.hs" }' -H ws://localhost:3000 "$@"
