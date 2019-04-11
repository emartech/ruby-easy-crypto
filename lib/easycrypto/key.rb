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

    def self.generate(password, salt_length = DEFAULT_SALT_LENGTH)
      salt = OpenSSL::Random.random_bytes(salt_length)

      generate_with_salt(password, salt)
    end

    def self.generate_with_salt(password, salt)
      key = OpenSSL::PKCS5.pbkdf2_hmac(
        password,
        salt,
        Key::ITERATION_COUNT,
        Key::KEY_LENGTH,
        Key::HASH_ALGO
      )

      new(key, salt)
    end
  end
end
