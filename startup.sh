#!/bin/bash

# Run Flok
flok-web &

# Run SuperCollider REPL
flok-repl -s "$1" -t sclang --extra '{ "sclang": "pw-jack sclang" }' 2>&1 &

# Run Tidal REPL
flok-repl -s "$1" -t tidal --extra '{ "bootScript": "/root/.config/tidal/startup.hs" }' 2>&1 &

# Run Bash
/bin/bash
