#include "db/statement.h"

#include <gtest/gtest.h>
#include <sqlite3.h>

#include <array>
#include <cstddef>
#include <cstdint>

namespace {

class StatementTest : public ::testing::Test {
 protected:
  sqlite3* db = nullptr;

  void SetUp() override {
    ASSERT_EQ(sqlite3_open(":memory:", &db), SQLITE_OK);
    ASSERT_EQ(sqlite3_exec(db, "CREATE TABLE t (id INTEGER, blob BLOB);",
                           nullptr, nullptr, nullptr),
              SQLITE_OK);
  }

  void TearDown() override {
    sqlite3_close(db);
  }
};

TEST_F(StatementTest, ValidSqlIsValid) {
  Statement stmt(db, "SELECT 1;");
  EXPECT_TRUE(stmt.IsValid());
}

TEST_F(StatementTest, InvalidSqlIsNotValid) {
  Statement stmt(db, "THIS IS NOT SQL;");
  EXPECT_FALSE(stmt.IsValid());
}

TEST_F(StatementTest, InvalidStatementDestructsCleanly) {
  {
    Statement stmt(db, "THIS IS NOT SQL;");
  }
  SUCCEED();
}

TEST_F(StatementTest, BindAndReadInt64) {
  Statement insert(db, "INSERT INTO t (id) VALUES (?);");
  ASSERT_TRUE(insert.IsValid());
  insert.BindInt64(1, 42);
  EXPECT_EQ(insert.Step(), SQLITE_DONE);

  Statement select(db, "SELECT id FROM t;");
  ASSERT_TRUE(select.IsValid());
  ASSERT_EQ(select.Step(), SQLITE_ROW);
  EXPECT_EQ(select.ColumnInt64(0), 42);
}

TEST_F(StatementTest, BindAndReadBlob) {
  const std::array<std::byte, 4> value{std::byte{1}, std::byte{2}, std::byte{3},
                                       std::byte{4}};

  Statement insert(db, "INSERT INTO t (blob) VALUES (?);");
  ASSERT_TRUE(insert.IsValid());
  insert.BindBlob(1, value);
  EXPECT_EQ(insert.Step(), SQLITE_DONE);

  Statement select(db, "SELECT blob FROM t;");
  ASSERT_TRUE(select.IsValid());
  ASSERT_EQ(select.Step(), SQLITE_ROW);

  std::array<std::byte, 4> out{};
  EXPECT_TRUE(select.ColumnBlob(0, out));
  EXPECT_EQ(out, value);
}

TEST_F(StatementTest, ColumnBlobFailsOnSizeMismatch) {
  const std::array<std::byte, 4> value{};

  Statement insert(db, "INSERT INTO t (blob) VALUES (?);");
  insert.BindBlob(1, value);
  ASSERT_EQ(insert.Step(), SQLITE_DONE);

  Statement select(db, "SELECT blob FROM t;");
  ASSERT_EQ(select.Step(), SQLITE_ROW);

  std::array<std::byte, 8> out{};
  EXPECT_FALSE(select.ColumnBlob(0, out));
}

TEST_F(StatementTest, ColumnBlobFailsOnNullValue) {
  Statement insert(db, "INSERT INTO t (id) VALUES (1);");
  ASSERT_EQ(insert.Step(), SQLITE_DONE);

  Statement select(db, "SELECT blob FROM t;");
  ASSERT_EQ(select.Step(), SQLITE_ROW);

  std::array<std::byte, 4> out{};
  EXPECT_FALSE(select.ColumnBlob(0, out));
}

TEST_F(StatementTest, StepReturnsDoneWhenNoRows) {
  Statement select(db, "SELECT id FROM t;");
  ASSERT_TRUE(select.IsValid());
  EXPECT_EQ(select.Step(), SQLITE_DONE);
}

}  // namespace
