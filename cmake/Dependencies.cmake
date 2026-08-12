include_guard(GLOBAL)

# googletest, fetched by Testing.cmake
set(GOOGLETEST_GIT_REPOSITORY "https://github.com/google/googletest.git" CACHE STRING "googletest repository URL")
set(GOOGLETEST_GIT_TAG "v1.17.0" CACHE STRING "googletest git tag to fetch")

# corrosion, fetched by Rust.cmake
set(CORROSION_GIT_REPOSITORY "https://github.com/corrosion-rs/corrosion.git" CACHE STRING "corrosion repository URL")
set(CORROSION_GIT_TAG "v0.6.1" CACHE STRING "corrosion git tag to fetch")

# SQLite amalgamation, fetched by SQLite.cmake
set(SQLITE_VERSION "3530400" CACHE STRING "SQLite amalgamation version, as used in sqlite.org release filenames")
set(SQLITE_RELEASE_YEAR "2026" CACHE STRING "Year sqlite.org filed this release under, i.e. the year folder in the download URL")
set(SQLITE_URL_BASE "https://www.sqlite.org" CACHE STRING "Base URL of the sqlite.org download site")
set(SQLITE_URL_HASH "SHA3_256=628a44cfe82c66aed1ccbbe85a562d2e33ebe64b3288981ed76285612227934e" CACHE STRING "Expected hash of the SQLite amalgamation archive, verified by FetchContent before it is extracted")
mark_as_advanced(SQLITE_URL_HASH)
