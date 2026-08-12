#include "db/statement.h"

#include <sqlite3.h>

Statement::Statement(sqlite3* db, std::string_view sql) : stmt_(nullptr) {
  sqlite3_prepare_v2(db, sql.data(), static_cast<int>(sql.size()), &stmt_,
                     nullptr);
}

Statement::~Statement() {
  sqlite3_finalize(stmt_);
}

bool Statement::IsValid() const noexcept {
  return stmt_ != nullptr;
}

void Statement::BindInt64(int index, std::int64_t value) {
  sqlite3_bind_int64(stmt_, index, value);
}

void Statement::BindBlobRaw(int index, const void* data, int size) {
  sqlite3_bind_blob(stmt_, index, data, size, SQLITE_STATIC);
}

int Statement::Step() {
  return sqlite3_step(stmt_);
}

std::int64_t Statement::ColumnInt64(int index) const {
  return sqlite3_column_int64(stmt_, index);
}

const void* Statement::ColumnBlobData(int index) const {
  return sqlite3_column_blob(stmt_, index);
}

int Statement::ColumnBytes(int index) const {
  return sqlite3_column_bytes(stmt_, index);
}
