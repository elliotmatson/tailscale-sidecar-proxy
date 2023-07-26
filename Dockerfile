FROM ghcr.io/tailscale/tailscale:v1.44.0
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD "start.sh"
