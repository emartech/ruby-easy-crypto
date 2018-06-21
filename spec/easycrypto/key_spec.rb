require 'easycrypto'

RSpec.describe EasyCrypto::Key do

  context 'generate' do
    it 'returns key with a salt of the specified length' do
      key = EasyCrypto::Key.generate('key password', 24)

      expect(key.salt.length).to be 24
    end

    it 'returns key with a 12 byte length salt' do
      key = EasyCrypto::Key.generate('key password')

      expect(key.salt.length).to be 12
    end
  end
end
