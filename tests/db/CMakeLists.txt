add_executable(db_test
    db_test.cc
)

target_link_libraries(db_test PRIVATE db)

ConfigTest(db_test)

add_executable(statement_test
    statement_test.cc
)

target_link_libraries(statement_test PRIVATE db sqlite3)

ConfigTest(statement_test)
