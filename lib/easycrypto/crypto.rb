require 'base64'
require 'openssl'
require_relative 'key'

module EasyCrypto
  class Crypto
    KEY_BITS = 256
    AES_MODE = :GCM
    IV_LEN = 12
    AUTH_TAG_LEN = 16

    def initialize(salt_length = DEFAULT_SALT_LENGTH)
      @salt_length = salt_length
    end

    def encrypt(password, plaintext)
      key = EasyCrypto::Key.generate(password, @salt_length)

      encrypt_with_key(key, plaintext)
    end

    def encrypt_with_key(key, plaintext)
      validate_key_type(key)
      validate_plaintext(plaintext)

      iv = OpenSSL::Random.random_bytes(Crypto::IV_LEN)
      cipher = create_cipher(key, iv)

      encrypted = cipher.update(plaintext) + cipher.final

      Base64.strict_encode64(key.salt + iv + encrypted + cipher.auth_tag)
    end

    def decrypt(password, ciphertext)
      salt = get_salt_from_ciphertext(ciphertext)
      key = EasyCrypto::Key.generate_with_salt(password, salt)

      decrypt_with_key(key, ciphertext)
    end

    def decrypt_with_key(key, ciphertext)
      validate_key_type(key)

      raw_ciphertext = Base64.strict_decode64(ciphertext)

      iv = raw_ciphertext[key.salt.length, IV_LEN]
      encrypted = raw_ciphertext[(key.salt.length + IV_LEN)..-(AUTH_TAG_LEN + 1)]
      auth_tag = raw_ciphertext[-AUTH_TAG_LEN..-1]

      decipher = create_decipher(key, iv, auth_tag)

      decipher.update(encrypted) + decipher.final
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

    def create_decipher(key, iv, auth_tag)
      decipher = OpenSSL::Cipher::AES.new(Crypto::KEY_BITS, Crypto::AES_MODE).decrypt
      decipher.key = key.key
      decipher.iv = iv
      decipher.auth_tag = auth_tag
      decipher
    end

    def get_salt_from_ciphertext(ciphertext)
      raw_ciphertext = Base64.strict_decode64(ciphertext)
      raw_ciphertext[0, @salt_length]
    end
  end
end
