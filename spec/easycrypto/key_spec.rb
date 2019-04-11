require 'easycrypto'

RSpec.describe EasyCrypto::Key do
  describe '#generate' do
    it 'returns key with a salt of the specified length' do
      key = EasyCrypto::Key.generate('key password', 24)

      expect(key.salt.length).to be 24
    end

    it 'returns key with a 12 byte length salt' do
      key = EasyCrypto::Key.generate('key password')

      expect(key.salt.length).to be 12
    end
  end

  describe '#generate_with_salt' do
    let(:salt) { 'aaaaaaaaaaaa' }

    it 'generates key with the given salt' do
      key = EasyCrypto::Key.generate_with_salt('key password', salt)

      expect(key.salt).to eq salt
    end

    it 'generates the expected key' do
      key = EasyCrypto::Key.generate_with_salt('key password', salt)

      expected_key = "\xC7\xE4\x89\xCB5\x86\xE0)Q)[u\xD6P\x87i\xC6\x13\xBE\xFE|\x19\x8A\xDB\xFB0\xB4\xE50\x12\x00\x95".force_encoding('ASCII-8BIT')
      expect(key.key).to eq expected_key
    end

    it 'generates the same key with the same password and salt' do
      key_1 = EasyCrypto::Key.generate_with_salt('key password', salt)
      key_2 = EasyCrypto::Key.generate_with_salt('key password', salt)

      expect(key_1.key).to eq key_2.key
    end
  end
end
