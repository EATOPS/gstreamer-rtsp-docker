# GStreamer Docker Images

`Dockerfile` and container registry for an Ubuntu docker image with a `gstreamer` RTSP server capability streaming videos from URI.

## Local usage with 'docker' CLI

### Locally pulling the image

The image is made public. No authentication needed.

`docker pull ghcr.io/eatops/gstreamer-rtsp-server:latest`.

### Streaming a test pattern

```
docker run -p 8556:8554 gstreamer-rtsp-server
```

Starts streaming a test pattern exposed on the host port 8556 at endpoint `/test`.
Show in VLC using 'Open Network Stream' and specify this URI: 'rtsp://127.0.0.1:8556/test'.

---

### Streaming a hosted video file

```
docker run -p 8556:8554 gstreamer-rtsp-server "/myvideo" "souphttpsrc location=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm ! decodebin ! x264enc ! rtph264pay name=pay0 pt=96"
```

Starts streaming a test video exposed on the host port 8556 at endpoint `/myvideo`.
Show in VLC using 'Open Network Stream' and specify this URI: 'rtsp://127.0.0.1:8556/myvideo'.

---

### Generic usage

```
docker run -p PORT:8554 gstreamer-rtsp-server "/endpoint1" "pipeline1 ! to ! stream" ["/endpoint2" "pipeline2 ! to ! stream"] [...]
```

## Streaming from an `Azure Container Instance`

```pwsh
az login # Note down subscription ID
az account set --subscription <id>

# Create resource group
az group create --name <name> --location <location>

# Create container instance
az container create --resource-group <name> --name <containername> --image ghcr.io/eatops/gstreamer-rtsp-server:latest --dns-name-label rtsp-label1 --ip-address Public --ports 8554 --command-line "./gst-rtsp-cli '/testendpoint' 'your ! pipeline'"

# Example of pipeline that plays a video hosted on the Internet:
# souphttpsrc location=https://www.freedesktop.org/software/gstreamer-sdk/data/media/sintel_trailer-480p.webm ! decodebin ! x264enc ! rtph264pay name=pay0 pt=96

# Checking logs
az container logs --resource-group <name> --name <containername>
# Should display:
# Creating endpoint rtsp://0.0.0.0:8554/xxx (your ! pipeline)
# RTSP Server Ready
```

## Updating the image

- Push your changes to the `Dockerfile`
- Push a tag starting with `v`
- A new image is automatically built and deployed