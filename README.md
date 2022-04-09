# Dockerfile for building Shairport-Sync for Raspberry Pi

## Building

docker build . -t istrukov/shairport-sync
docker push istrukov/shairport-sync

## Running

docker run --device=/dev/snd:/dev/snd --network=host --name=shairport-sync istrukov/shairport-sync
