# FastAPI SQLModel cheatsheet (~118 cols wide)
cheatsheet_fastapi_sqlmodel() {
    local CYAN=$'\033[1;36m'
    local GREEN=$'\033[1;32m'
    local PINK=$'\033[1;38;5;205m'
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
    _pentry() {
        printf "${DIM}║${NC} ${PINK}%-${CW}s${NC} ${DIM}║${NC} ${PINK}%-${CW}s${NC} ${DIM}║${NC} ${PINK}%-${CW}s${NC} ${DIM}║${NC}\n" \
            "$1" "$3" "$5"
        printf "${DIM}║  %-$((CW-1))s ║  %-$((CW-1))s ║  %-$((CW-1))s ║${NC}\n" \
            "$2" "$4" "$6"
    }

    local H; H=$(printf '═%.0s' $(seq 1 $((CW + 2))))
    printf "${DIM}╔${H}╦${H}╦${H}╗${NC}\n"
    _dhdr "MODEL DEFINITION" "ENGINE & SESSION" "CRUD & QUERIES"
    printf "${DIM}╠${H}╬${H}╬${H}╣${NC}\n"
    _entry \
        "class Hero(SQLModel, table=True):"  "define a DB-mapped table model"  \
        "engine = create_engine(url)"        "create database engine"           \
        "session.add(hero)"                  "stage object for insert/update"
    _entry \
        "class Hero(SQLModel):"              "data/response model, no table"    \
        "create_engine(url, echo=True)"      "log all SQL statements"           \
        "session.commit()"                   "persist staged changes to DB"
    _entry \
        "name: str"                          "required non-nullable column"     \
        "SQLModel.metadata.create_all(eng)"  "create all defined tables"        \
        "session.refresh(hero)"              "sync object state from DB"
    _entry \
        "age: int | None = None"             "optional nullable int column"     \
        "with Session(engine) as session:"   "open a managed session block"     \
        "session.get(Hero, hero_id)"         "fetch single row by primary key"
    _entry \
        "name: str = Field(index=True)"      "add a DB index on this column"    \
        "def get_session():"                 "FastAPI session dependency fn"    \
        "session.delete(hero)"               "stage object for deletion"
    _entry \
        "Field(foreign_key=\"team.id\")"     "FK column pointing to team"       \
        "  yield Session(engine)"            "dep fn body (see above)"          \
        "session.exec(select(Hero)).all()"   "fetch all rows as a list"
    _entry \
        "Relationship(back_populates=...)"   "bidirectional FK relationship"    \
        "@app.on_event(\"startup\")"         "create tables at app startup"     \
        "select(Hero).where(Hero.age > 18)"  "filter query by condition"
    _entry \
        "class HeroRead(Hero):"              "output schema (subset of fields)" \
        "async def lifespan(app: FastAPI):"  "new-style lifespan handler"       \
        "select(Hero).offset(n).limit(m)"    "paginate: skip n, return m rows"
    printf "${DIM}╠${H}╬${H}╬${H}╣${NC}\n"
    _dhdr "FIELD() - DB SCHEMA" "FIELD() - VALIDATION" "FIELD() - CONSTRAINTS"
    printf "${DIM}╠${H}╬${H}╬${H}╣${NC}\n"
    _pentry \
        "primary_key=True"             "marks column as table primary key"  \
        "default=None"                 "value used when none is provided"   \
        "min_length=1"                 "minimum string length"
    _pentry \
        "foreign_key=\"user.id\""      "links to another table's column"    \
        "default_factory=list"         "callable to generate a default"     \
        "max_length=100"               "maximum string length"
    _pentry \
        "index=True"                   "creates DB index for fast lookups"  \
        "alias=\"userName\""           "JSON key name (differs from field)" \
        "pattern=\"^[A-Z]+\$\""        "regex pattern validation"
    _pentry \
        "unique=True"                  "enforces no duplicate col values"   \
        "title=\"User Name\""          "field title for OpenAPI docs"       \
        "gt=0 / ge=0"                  "value must be > n or >= n"
    _pentry \
        "nullable=False"               "override NULL inference from type"  \
        "description=\"Hero age\""     "field description for API docs"     \
        "lt=100 / le=100"              "value must be < n or <= n"
    _pentry \
        "sa_column=Column(...)"        "pass raw SQLAlchemy Column object"  \
        "exclude=True"                 "hide from .dict() / JSON output"    \
        "multiple_of=5"                "value must be a multiple of n"
    _pentry \
        "sa_column_args=[...]"         "extra SQLAlchemy positional args"   \
        "validate_default=True"        "also validate the default value"    \
        "max_digits=10"                "max total digits (Decimal)"
    _pentry \
        "sa_column_kwargs={...}"       "extra SQLAlchemy keyword args"      \
        "repr=False"                   "exclude field from __repr__"        \
        "decimal_places=2"             "max decimal places (Decimal)"
    printf "${DIM}╚${H}╩${H}╩${H}╝${NC}\n\n"

    unset -f _entry _pentry _dhdr
}
