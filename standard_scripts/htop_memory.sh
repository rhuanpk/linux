#!/usr/bin/env bash
echo "RAM: $(($(free -m | tr -s ' ' | head -n 2 | tail -n 1 | cut -d ' ' -f 3)+27)) mb"
