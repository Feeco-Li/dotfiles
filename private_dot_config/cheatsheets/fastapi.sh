# FastAPI CLI cheatsheet (~118 cols wide)
cheatsheet_fastapi() {
    local CYAN=$'\033[1;36m'
    local GREEN=$'\033[1;32m'
    local BOLD=$'\033[1m'
    local DIM=$'\033[2m'
    local NC=$'\033[0m'
    local CW=36

    _dhdr() {
        printf "${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC} ${BOLD}${CYAN}%-${CW}s${NC} ${DIM}║${NC}\n" "$1" "$2" "$3"
    }
    # args: cmd1 desc1 cmd2 desc2 cmd3 desc3
    _entry() {
        printf "${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC} ${GREEN}%-${CW}s${NC} ${DIM}║${NC}\n" \
            "$1" "$3" "$5"
        printf "${DIM}║  %-$((CW-1))s ║  %-$((CW-1))s ║  %-$((CW-1))s ║${NC}\n" \
            "$2" "$4" "$6"
    }

    local H; H=$(printf '═%.0s' $(seq 1 $((CW + 2))))
    printf "${DIM}╔${H}╦${H}╦${H}╗${NC}\n"
    _dhdr "DEVELOPMENT  (fastapi dev)" "PRODUCTION  (fastapi run)" "CLOUD & PATTERNS"
    printf "${DIM}╠${H}╬${H}╬${H}╣${NC}\n"
    _entry \
        "fastapi dev"                        "auto-detect app, start dev server"  \
        "fastapi run"                        "auto-detect app, production mode"   \
        "fastapi login"                      "login to FastAPI Cloud"
    _entry \
        "fastapi dev main.py"                "dev server with explicit file"      \
        "fastapi run main.py"                "production with explicit file"      \
        "fastapi deploy"                     "deploy to FastAPI Cloud"
    _entry \
        "fastapi dev --host 0.0.0.0"         "expose on all interfaces"           \
        "fastapi run --host 127.0.0.1"       "bind to localhost only"             \
        "fastapi cloud"                      "manage cloud deployments"
    _entry \
        "fastapi dev --port 8080"            "serve on custom port"               \
        "fastapi run --port 80"              "serve on port 80"                   \
        "fastapi --version"                  "show CLI version"
    _entry \
        "fastapi dev --no-reload"            "disable auto-reload"                \
        "fastapi run --workers 4"            "multiple worker processes"          \
        "uv run fastapi dev"                 "dev server in project env"
    _entry \
        "fastapi dev --reload-dir src"       "watch specific directory"           \
        "fastapi run --root-path /api"       "set path prefix for proxied apps"   \
        "uv run fastapi run main.py"         "production server via uv"
    _entry \
        "fastapi dev --app myapp"            "specify app variable name"          \
        "fastapi run --no-proxy-headers"     "disable proxy header trust"         \
        "fastapi dev app/"                   "detect app in package directory"
    _entry \
        "fastapi dev -e main:app"            "specify full import string"         \
        "fastapi run -e main:app"            "specify full import string"         \
        "fastapi dev --forwarded-allow-ips *" "trust all proxy IPs"
    printf "${DIM}╚${H}╩${H}╩${H}╝${NC}\n\n"

    unset -f _entry _dhdr
}
