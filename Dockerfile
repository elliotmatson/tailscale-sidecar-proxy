FROM tailscale/tailscale:v1.38.1
COPY start.sh /usr/bin/start.sh
RUN chmod +x /usr/bin/start.sh
CMD "start.sh"
