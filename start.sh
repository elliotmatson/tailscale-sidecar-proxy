#!/bin/ash

cleanup() {
    echo "Cleaning up..."
    until tailscale logout; do
        sleep 0.1
    done
    kill -TERM ${PID}
    wait ${PID}
    exit 1
}

trap cleanup INT TERM

echo "Starting Tailscale daemon"
tailscaled --tun=userspace-networking --statedir=/var/lib/tailscale_state/ &
PID=$!

echo "Starting Tailscale"
until tailscale up --authkey="${TAILSCALE_AUTH_KEY}" --hostname="${TAILSCALE_HOSTNAME}"; do
    sleep 0.1
done

echo "adding proxy entry"
until tailscale serve https / http://localhost:${TAILSCALE_SERVE_PORT}; do
    sleep 0.1
done

# if TAILSCALE_FUNNEL is set, add a funnel entry
if ${TAILSCALE_FUNNEL:-false}; then
    echo "adding funnel entry"
    until tailscale funnel 443 on; do
        sleep 0.1
    done
fi
tailscale status
wait ${PID}
