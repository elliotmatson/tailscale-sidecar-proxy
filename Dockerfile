FROM ghcr.io/tailscale/tailscale:v1.48.1
ARG S6_OVERLAY_VERSION=3.1.5.0

RUN apk add --no-cache wget bash iptables jq

# install s6 overlay
ARG TARGETARCH
RUN if [ "$TARGETARCH" = "amd64" ]; then ARCHITECTURE=x86_64; elif [ "$TARGETARCH" = "arm/v7" ]; then ARCHITECTURE=arm; elif [ "$TARGETARCH" = "arm/v6" ]; then ARCHITECTURE=armhf; elif [ "$TARGETARCH" = "arm64" ]; then ARCHITECTURE=aarch64; else ARCHITECTURE=amd64; fi \
    && echo "Architecture: $ARCHITECTURE" \
    && echo "Downloading v${S6_OVERLAY_VERSION}/s6-overlay-${ARCHITECTURE}.tar.xz" \   
    && wget "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${ARCHITECTURE}.tar.xz" -O "/tmp/s6-overlay-${ARCHITECTURE}.tar.xz" \
    && tar -Jxpf "/tmp/s6-overlay-${ARCHITECTURE}.tar.xz" -C / \
    && wget "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" -O "/tmp/s6-overlay-noarch.tar.xz" \
    && tar -Jxpf "/tmp/s6-overlay-noarch.tar.xz" -C / 
ENTRYPOINT ["/init"]
CMD []

COPY root/ /


#COPY start.sh /usr/bin/start.sh
#RUN chmod +x /usr/bin/start.sh
#CMD "start.sh"
