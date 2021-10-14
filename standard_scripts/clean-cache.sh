#!/usr/bin/env bash

# Limpa a memória cache

sync; echo 3 > /proc/sys/vm/drop_caches
