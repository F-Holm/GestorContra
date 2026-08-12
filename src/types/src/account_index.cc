#include "types/account_index.h"

#include <cstring>
#include <span>

#include "crypto/crypto.h"

AccountIndex::AccountIndex() noexcept
    : description(), iv_description(), tag_description(), position(-1) {
  this->SetZero();
}

AccountIndex::AccountIndex(std::int64_t position) noexcept
    : description(), iv_description(), tag_description(), position(position) {
  this->SetZero();
}

AccountIndex::AccountIndex(AccountBinary& account) noexcept
    : description(account.description),
      iv_description(account.iv_description),
      tag_description(account.tag_description),
      position(-1) {
}

AccountIndex::AccountIndex(AccountBinary& account,
                           std::int64_t position) noexcept
    : description(account.description),
      iv_description(account.iv_description),
      tag_description(account.tag_description),
      position(position) {
}

void AccountIndex::SetZero() noexcept {
  Crypto::SecureClear(std::span{description});
  Crypto::SecureClear(std::span{iv_description});
  Crypto::SecureClear(std::span{tag_description});
}

AccountIndex::~AccountIndex() noexcept {
  this->SetZero();
  position = 0;
}
