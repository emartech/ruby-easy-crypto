require 'easycrypto'

RSpec.describe EasyCrypto::Crypto do
  it 'has a version number' do
    expect(EasyCrypto::VERSION).not_to be nil
  end

  context 'encrypt' do
    it 'returns encrypted text in a single line' do
      ecrypto = EasyCrypto::Crypto.new
      key = EasyCrypto::Key.generate('key password', 12)
      encrypted = ecrypto.encrypt_with_key(key, 'plain text')
      expect(encrypted).not_to include("\n")
    end

    it 'raise error if the encryptable data is not a string' do
      ecrypto = EasyCrypto::Crypto.new
      key = EasyCrypto::Key.generate('key password', 12)
      expect{
        ecrypto.encrypt_with_key(key, 1234)
      }.to raise_error(TypeError, 'Encryptable data must be a string')
    end

    it 'raise error if the encryptable data is empty' do
      ecrypto = EasyCrypto::Crypto.new
      key = EasyCrypto::Key.generate('key password', 12)
      expect{
        ecrypto.encrypt_with_key(key, '')
      }.to raise_error(ArgumentError, 'Encryptable data must not be empty')
    end
  end
end
