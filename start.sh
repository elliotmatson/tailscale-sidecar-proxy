#!/bin/ash
trap 'kill -TERM $PID' TERM INT

echo "Starting Tailscale daemon"
tailscaled --tun=userspace-networking --statedir=${TAILSCALE_STATEDIR_ARG} &
PID=$!

echo "Starting Tailscale"
until tailscale up --authkey="${TAILSCALE_AUTH_KEY}" --hostname="${TAILSCALE_HOSTNAME}"; do
    sleep 0.1
done

echo "adding proxy entry"
until tailscale serve / proxy ${TAILSCALE_SERVE_PORT}; do
    sleep 0.1
done
tailscale status
wait ${PID}
wait ${PID}
