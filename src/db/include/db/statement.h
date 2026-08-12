#pragma once

#include <array>
#include <cstddef>
#include <cstdint>
#include <cstring>
#include <string_view>

struct sqlite3;
struct sqlite3_stmt;

class Statement {
 public:
  Statement(sqlite3* db, std::string_view sql);
  ~Statement();

  Statement(const Statement&) = delete;
  Statement& operator=(const Statement&) = delete;

  [[nodiscard]] bool IsValid() const noexcept;

  void BindInt64(int index, std::int64_t value);

  template <std::size_t N>
  void BindBlob(int index, const std::array<std::byte, N>& value) {
    BindBlobRaw(index, value.data(), static_cast<int>(N));
  }

  int Step();

  [[nodiscard]] std::int64_t ColumnInt64(int index) const;

  template <std::size_t N>
  bool ColumnBlob(int index, std::array<std::byte, N>& out) const {
    const void* blob = ColumnBlobData(index);
    if (blob == nullptr || ColumnBytes(index) != static_cast<int>(N)) {
      return false;
    }
    std::memcpy(out.data(), blob, N);
    return true;
  }

 private:
  sqlite3_stmt* stmt_ = nullptr;

  void BindBlobRaw(int index, const void* data, int size);
  [[nodiscard]] const void* ColumnBlobData(int index) const;
  [[nodiscard]] int ColumnBytes(int index) const;
};
