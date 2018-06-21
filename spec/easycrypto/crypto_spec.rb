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
  end
end
