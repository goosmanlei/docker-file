#!/bin/bash
# Manage the jupyterlab container (macpod-for-fastai-course)
# - Maps local port 8001 -> container port 8888 (JupyterLab)
# - Maps ~/llmpath -> /workspace (JupyterLab root dir)

CONTAINER_NAME="jupyterlab"
IMAGE="goosmanlei/macpod-for-fastai-course"
PORT="8001"

get_state() {
    docker inspect -f '{{.State.Status}}' "$CONTAINER_NAME" 2>/dev/null
}

do_start() {
    local state
    state=$(get_state)
    case "$state" in
        running)
            echo "Container '$CONTAINER_NAME' is already running."
            echo "  http://localhost:$PORT"
            ;;
        exited|created)
            echo "Starting existing container '$CONTAINER_NAME'..."
            docker start "$CONTAINER_NAME"
            echo "  http://localhost:$PORT"
            ;;
        *)
            echo "Creating and starting container '$CONTAINER_NAME'..."
            docker run -d \
                --name "$CONTAINER_NAME" \
                -p "$PORT":8888 \
                -v "$HOME/llmpath:/workspace" \
                "$IMAGE"
            echo "  http://localhost:$PORT"
            ;;
    esac
}

do_stop() {
    local state
    state=$(get_state)
    if [ "$state" = "running" ]; then
        echo "Stopping container '$CONTAINER_NAME'..."
        docker stop "$CONTAINER_NAME"
    else
        echo "Container '$CONTAINER_NAME' is not running."
    fi
}

do_restart() {
    local state
    state=$(get_state)
    case "$state" in
        running)
            echo "Restarting container '$CONTAINER_NAME'..."
            docker restart "$CONTAINER_NAME"
            echo "  http://localhost:$PORT"
            ;;
        exited|created)
            do_start
            ;;
        *)
            echo "Container '$CONTAINER_NAME' does not exist. Starting fresh..."
            do_start
            ;;
    esac
}

do_status() {
    local state
    state=$(get_state)
    if [ -z "$state" ]; then
        echo "Container '$CONTAINER_NAME' does not exist."
    else
        echo "Container '$CONTAINER_NAME': $state"
        if [ "$state" = "running" ]; then
            echo "  URL:   http://localhost:$PORT"
            echo "  Image: $(docker inspect -f '{{.Config.Image}}' "$CONTAINER_NAME")"
            echo "  Up:    $(docker inspect -f '{{.State.StartedAt}}' "$CONTAINER_NAME")"
        fi
    fi
}

do_logs() {
    local state
    state=$(get_state)
    if [ -z "$state" ]; then
        echo "Container '$CONTAINER_NAME' does not exist."
    else
        docker logs -f "$CONTAINER_NAME"
    fi
}

do_rm() {
    local state
    state=$(get_state)
    if [ -z "$state" ]; then
        echo "Container '$CONTAINER_NAME' does not exist."
        return
    fi
    if [ "$state" = "running" ]; then
        echo "Stopping container first..."
        docker stop "$CONTAINER_NAME"
    fi
    echo "Removing container '$CONTAINER_NAME'..."
    docker rm "$CONTAINER_NAME"
}

do_shell() {
    local state
    state=$(get_state)
    if [ "$state" = "running" ]; then
        docker exec -it "$CONTAINER_NAME" bash
    else
        echo "Container '$CONTAINER_NAME' is not running."
    fi
}

case "${1:-start}" in
    start)   do_start   ;;
    stop)    do_stop    ;;
    restart) do_restart ;;
    status)  do_status  ;;
    logs)    do_logs    ;;
    rm)      do_rm      ;;
    shell)   do_shell   ;;
    *)
        echo "Usage: $0 {start|stop|restart|status|logs|rm|shell}"
        echo ""
        echo "Commands:"
        echo "  start    Start the container (default if no command given)"
        echo "  stop     Stop the container"
        echo "  restart  Restart the container"
        echo "  status   Show container status"
        echo "  logs     Follow container logs"
        echo "  rm       Stop and remove the container"
        echo "  shell    Open a bash shell in the running container"
        exit 1
        ;;
esac
