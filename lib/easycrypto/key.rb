# frozen_string_literal: true

require 'openssl'

module EasyCrypto
  class Key
    ITERATION_COUNT = 10_000
    KEY_LENGTH = 32
    HASH_ALGO = 'sha256'

    attr_reader :key, :salt

    def initialize(key, salt)
      @key = key
      @salt = salt
    end

    def self.generate(password, salt_length)
      salt = OpenSSL::Random.random_bytes(salt_length)
      key = OpenSSL::KDF.pbkdf2_hmac(
        password,
        salt: salt,
        iterations: Key::ITERATION_COUNT,
        length: Key::KEY_LENGTH,
        hash: Key::HASH_ALGO
      )

      new(key, salt)
    end
  end
end
