FROM ghcr.io/tailscale/tailscale:v1.48.1
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD "start.sh"
