require 'base64'
require 'openssl'
require_relative 'key'

module EasyCrypto
  class Crypto
    KEY_BITS = 256
    AES_MODE = :GCM
    IV_LEN = 12

    def encrypt_with_key(key, plaintext)
      validate_key_type(key)
      validate_plaintext(plaintext)

      iv = OpenSSL::Random.random_bytes(Crypto::IV_LEN)
      cipher = create_cipher(key, iv)

      encrypted = cipher.update(plaintext) + cipher.final

      Base64.strict_encode64(key.salt + iv + encrypted + cipher.auth_tag)
    end

    private

    def validate_key_type(key)
      raise TypeError, 'key must have Key type' unless key.is_a?(EasyCrypto::Key)
    end

    def validate_plaintext(plaintext)
      raise TypeError, 'Encryptable data must be a string' unless plaintext.is_a?(String)
      raise ArgumentError, 'Encryptable data must not be empty' if plaintext.empty?
    end

    def create_cipher(key, iv)
      cipher = OpenSSL::Cipher::AES.new(Crypto::KEY_BITS, Crypto::AES_MODE).encrypt
      cipher.key = key.key
      cipher.iv = iv
      cipher
    end
  end
end
