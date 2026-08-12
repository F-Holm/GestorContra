include_guard(GLOBAL)

include(Dependencies)
include(FetchContent)

FetchContent_Declare(
    sqlite3
    URL "${SQLITE_URL_BASE}/${SQLITE_RELEASE_YEAR}/sqlite-amalgamation-${SQLITE_VERSION}.zip"
    URL_HASH ${SQLITE_URL_HASH}
)

FetchContent_MakeAvailable(sqlite3)

add_library(sqlite3 STATIC
    "${sqlite3_SOURCE_DIR}/sqlite3.c"
)

target_include_directories(sqlite3 SYSTEM PUBLIC
    "${sqlite3_SOURCE_DIR}"
)

target_compile_definitions(sqlite3 PUBLIC
    SQLITE_THREADSAFE=1
    SQLITE_DQS=0
    SQLITE_ENABLE_FTS5
)

find_package(Threads REQUIRED)
target_link_libraries(sqlite3 PUBLIC Threads::Threads ${CMAKE_DL_LIBS})
