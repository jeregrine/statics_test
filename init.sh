#!/bin/sh

ls -la /app
cat "VOLUME GOOD" > /data/volume.txt

elixir /app/scratch.exs
