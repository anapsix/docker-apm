## Elastic's APM in Docker
Smaller Docker image for Elastic's APM with Alpine Linux

[![](https://images.microbadger.com/badges/image/anapsix/apm:latest.svg)](https://microbadger.com/images/anapsix/apm:latest)

### Build
```
docker build . -t apm
```

### Run
Create your custom `apm-server.yaml` file, and pass it to container
```
docker run -it --rm \
           -v $(pwd)/apm-server.yaml:/usr/share/apm-server/apm-server.yaml \
           -p 8200:8200 anapsix/apm
```