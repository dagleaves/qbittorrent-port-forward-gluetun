# qbittorrent-port-forward-gluetun

A shell script and Docker container for automatically setting qBittorrent's listening port from Gluetun's control server.

## Config

### Environment Variables

| Variable     | Example                     | Default                      | Description                                                     |
|--------------|-----------------------------|------------------------------|-----------------------------------------------------------------|
| QBT_USERNAME | `username`                  | `admin`                      | qBittorrent username                                            |
| QBT_PASSWORD | `password`                  | `adminadmin`                 | qBittorrent password                                            |
| QBT_ADDR     | `http://192.168.1.100:8080` | `http://localhost:8080`      | HTTP URL for the qBittorrent web UI, with port                  |
| GLUE_USERNAME| `username`                  | `admin`                      | Username for the gluetun web UI                                 |
| GLUE_PASSWORD| `password`                  | `adminadmin`                 | Password for the gluetun web UI                                 |
| GLUE_USERNAME| `http://192.168.1.100:8000` | `http://localhost:8000`      | HTTP URL for the gluetun web UI, with port                      |

## Context

Made for use with [gluetun](https://github.com/qdm12/gluetun):

* PIA Environment variable: `PRIVATE_INTERNET_ACCESS_VPN_PORT_FORWARDING=on`
* ProtonVPN Environment variables: 
  - `PORT_FORWARD_ONLY=on`
  - `VPN_PORT_FORWARDING=on`
  - `VPN_PORT_FORWARDING_PROVIDER=protonvpn`
  
## Docker Compose Example
```yaml
services:
  qbittorrent-port-forward-gluetun:
    image: dagleaves/qbittorrent-port-forward-gluetun:latest
    container_name: qbittorrent-port-forward-gluetun
    restart: unless-stopped
    environment:
      - QBT_USERNAME=username
      - QBT_PASSWORD=password
      - QBT_ADDR=http://192.168.1.100:8080
      - GLUE_USERNAME=username
      - GLUE_PASSWORD=password
      - GLUE_ADDR=http://192.168.1.100:8000
```

## Development

### Build Image

`docker build . -t qbittorrent-port-forwarder`

### Run Container

`docker run --rm -it -e QBT_ADDR=http://192.168.1.100:8080 -v $(pwd)/config:/config qbittorrent-port-forwarder:latest`
