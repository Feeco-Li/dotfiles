# Docker command cheatsheet (~186 cols wide, best in fullscreen)
cheatsheet_docker() {
    local CYAN=$'\033[1;36m'
    local GREEN=$'\033[1;32m'
    local BOLD=$'\033[1m'
    local DIM=$'\033[2m'
    local NC=$'\033[0m'
    local CW=34

    _dhdr() {
        printf "${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC}\n" "$1" "$2" "$3" "$4" "$5"
    }
    # args: cmd1 desc1 cmd2 desc2 cmd3 desc3 cmd4 desc4 cmd5 desc5
    _entry() {
        printf "${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC}\n" \
            "$1" "$3" "$5" "$7" "$9"
        printf "${DIM}║  %-$((CW-1))s ║  %-$((CW-1))s ║  %-$((CW-1))s ║  %-$((CW-1))s ║  %-$((CW-1))s ║${NC}\n" \
            "$2" "$4" "$6" "$8" "${10}"
    }

    local H; H=$(printf '═%.0s' $(seq 1 $((CW + 2))))
    printf "${DIM}╔${H}╦${H}╦${H}╦${H}╦${H}╗${NC}\n"
    _dhdr "IMAGES & REGISTRY" "CONTAINERS" "EXEC & LOGS" "VOLUMES & NETWORKS" "COMPOSE & CLEANUP"
    printf "${DIM}╠${H}╬${H}╬${H}╬${H}╬${H}╣${NC}\n"
    _entry \
        "docker pull <img>"              "pull image from registry"        \
        "docker run -d --name <n> <img>" "run named container detached"    \
        "docker exec -it <c> bash"       "open shell in running container"  \
        "docker volume ls"               "list all volumes"                \
        "docker compose up -d"           "start all services detached"
    _entry \
        "docker images"                  "list local images"               \
        "docker run -it <img> bash"      "interactive shell in container"   \
        "docker exec <c> <cmd>"          "run command in container"        \
        "docker volume create <n>"       "create a named volume"           \
        "docker compose up --build"      "rebuild and start services"
    _entry \
        "docker rmi <img>"               "remove a local image"            \
        "docker run --rm <img>"          "auto-remove container on exit"   \
        "docker logs -f <c>"             "stream container logs live"      \
        "docker volume rm <n>"           "remove a volume"                 \
        "docker compose down -v"         "stop and remove with volumes"
    _entry \
        "docker build -t <n> ."          "build image from Dockerfile"     \
        "docker run -p 8080:80 <img>"    "map host to container port"      \
        "docker logs --tail 100 <c>"     "show last 100 log lines"         \
        "docker volume prune"            "remove all unused volumes"       \
        "docker compose stop"            "stop services keep containers"
    _entry \
        "docker build --no-cache ."      "rebuild ignoring layer cache"    \
        "docker run -v /h:/c <img>"      "mount host path as volume"       \
        "docker logs --since 1h <c>"     "show logs since last hour"       \
        "docker network ls"              "list all networks"               \
        "docker compose watch"           "hot-reload on file changes"
    _entry \
        "docker tag <img> <tag>"         "tag image with new name:tag"     \
        "docker run --env-file .env <img>" "load env vars from file"       \
        "docker inspect <c>"             "show full container metadata"    \
        "docker network create <n>"      "create a custom network"         \
        "docker compose restart <s>"     "restart a specific service"
    _entry \
        "docker push <name:tag>"         "push image to registry"          \
        "docker ps / ps -a"              "list running / all containers"   \
        "docker stats"                   "live CPU and memory usage"       \
        "docker network rm <n>"          "remove a network"                \
        "docker compose logs -f"         "stream logs for all services"
    _entry \
        "docker login"                   "authenticate with registry"      \
        "docker start/stop/restart <c>"  "start stop or restart container" \
        "docker top <c>"                 "list processes in container"     \
        "docker network connect <n> <c>" "attach container to network"     \
        "docker compose exec <s> bash"   "shell into a running service"
    _entry \
        "docker search <term>"           "search images on Docker Hub"     \
        "docker kill / rm -f <c>"        "force stop or remove container"  \
        "docker port <c>"                "show port mappings"              \
        "docker network inspect <n>"     "show network details"            \
        "docker compose ps"              "list service container status"
    _entry \
        "docker history <img>"           "show image layer history"        \
        "docker cp <c>:/path ./"         "copy files from container"       \
        "docker info"                    "show Docker system info"         \
        "docker network prune"           "remove unused networks"          \
        "docker system prune -a"         "remove all unused resources"
    printf "${DIM}╚${H}╩${H}╩${H}╩${H}╩${H}╝${NC}\n\n"

    unset -f _entry _dhdr
}
