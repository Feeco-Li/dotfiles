# uv Python package manager cheatsheet (~196 cols wide, best in fullscreen)
cheatsheet_uv() {
    local CYAN=$'\033[1;36m'
    local GREEN=$'\033[1;32m'
    local BOLD=$'\033[1m'
    local DIM=$'\033[2m'
    local NC=$'\033[0m'
    local CW=36

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
    _dhdr "PROJECT" "SYNC, LOCK & BUILD" "RUN" "PYTHON VERSIONS" "VENV, PIP & TOOLS"
    printf "${DIM}╠${H}╬${H}╬${H}╬${H}╬${H}╣${NC}\n"
    _entry \
        "uv init"                        "initialize new project"           \
        "uv sync"                        "sync project dependencies"        \
        "uv run <cmd>"                   "run in project environment"       \
        "uv python install 3.12"         "install Python version"           \
        "uv venv"                        "create .venv in current dir"
    _entry \
        "uv init --app <name>"           "create application project"       \
        "uv sync --frozen"               "sync without updating lock"       \
        "uv run python"                  "launch Python interpreter"        \
        "uv python install"              "install pinned version"           \
        "uv pip install <pkg>"           "install package into venv"
    _entry \
        "uv init --lib <name>"           "create library project"           \
        "uv sync --no-dev"               "sync production deps only"        \
        "uv run script.py"               "execute a Python script"          \
        "uv python upgrade 3.12"         "upgrade Python version"           \
        "uv pip install -r requirements.txt" "install from requirements file"
    _entry \
        "uv add <pkg>"                   "add dependency"                   \
        "uv lock"                        "update lockfile"                  \
        "uv run -m <module>"             "run Python module"                \
        "uv python list"                 "list available versions"          \
        "uv pip install -e ."            "install in editable mode"
    _entry \
        "uv add --dev <pkg>"             "add dev dependency"               \
        "uv lock --frozen"               "assert lockfile unchanged"        \
        "uv run --python 3.12 <cmd>"     "run with specific Python"         \
        "uv python list --all-versions"  "list all installable versions"    \
        "uv pip uninstall <pkg>"         "uninstall package"
    _entry \
        "uv add --group <g> <pkg>"       "add to dependency group"          \
        "uv export --format requirements-txt" "export to requirements-txt"  \
        "uv run --with <pkg> <cmd>"      "run with extra package"           \
        "uv python pin 3.12"             "pin version for project"          \
        "uv pip list"                    "list installed packages"
    _entry \
        "uv remove <pkg>"                "remove dependency"                \
        "uv build"                       "build source dist and wheel"      \
        "uv run --frozen"                "run without updating lockfile"    \
        "uv python find"                 "find active Python install"       \
        "uv pip freeze"                  "output as requirements format"
    _entry \
        "uv version"                     "show or update project version"   \
        "uv publish"                     "publish package to PyPI"          \
        "uv run --no-project <cmd>"      "run outside project context"      \
        "uv python find 3.12"            "find specific version"            \
        "uv tool install <tool>"         "install CLI tool globally"
    _entry \
        "uv audit"                       "check for vulnerabilities"        \
        "uv cache clean"                 "clear the download cache"         \
        "uv run --isolated"              "run in isolated environment"      \
        "uv python uninstall 3.12"       "remove Python version"            \
        "uv tool upgrade <tool>"         "upgrade a global tool"
    _entry \
        "uv tree"                        "show dependency tree"             \
        "uv self update"                 "update uv to latest version"      \
        "uvx <tool>"                     "run tool without installing"      \
        "uv python dir"                  "show Python install directory"    \
        "uv tool list"                   "list installed global tools"
    printf "${DIM}╚${H}╩${H}╩${H}╩${H}╩${H}╝${NC}\n\n"

    unset -f _entry _dhdr
}
