require 'easycrypto'

RSpec.describe EasyCrypto::Crypto do
  let(:salt) { 'aaaaaaaaaaaa' }
  let(:iv) { 'bbbbbbbbbbbb' }
  let(:password) { 'some password' }
  let(:data) { 'some data' }
  let(:key) { EasyCrypto::Key.generate_with_salt(password, salt) }

  it 'has a version number' do
    expect(EasyCrypto::VERSION).not_to be nil
  end

  it 'can encrypt and decrypt data' do
    ciphertext = subject.encrypt(password, data)
    plaintext = subject.decrypt(password, ciphertext)

    expect(plaintext).to eq data
  end

  it 'can encrypt and decrypt data with given key' do
    key = EasyCrypto::Key.generate(password)

    ciphertext = subject.encrypt_with_key(key, data)
    plaintext = subject.decrypt_with_key(key, ciphertext)

    expect(plaintext).to eq data
  end

  describe '#encrypt' do
    before do
      allow(OpenSSL::Random).to receive(:random_bytes).and_return(iv)
      allow(EasyCrypto::Key).to receive(:generate).and_return(key)
    end

    it 'can encrypt data' do
      result = subject.encrypt(password, data)
      raw_result = Base64.strict_decode64(result)

      expect(raw_result[0,12]).to eq salt
      expect(raw_result[12,12]).to eq iv
    end
  end

  describe '#encrypt_with_key' do
    before do
      allow(OpenSSL::Random).to receive(:random_bytes).and_return(iv)
    end

    it 'returns encrypted text as a single line' do
      ciphertext = subject.encrypt_with_key(key, data)

      expect(ciphertext).not_to include("\n")
    end

    it 'raise error if the encryptable data is not a string' do
      expect{
        subject.encrypt_with_key(key, 1234)
      }.to raise_error(TypeError, 'Encryptable data must be a string')
    end

    it 'raise error if the encryptable data is empty' do
      expect{
        subject.encrypt_with_key(key, '')
      }.to raise_error(ArgumentError, 'Encryptable data must not be empty')
    end

    it 'can encrypt data with given key' do
      expected_ciphertext = 'YWFhYWFhYWFhYWFhYmJiYmJiYmJiYmJifAUY9TEdvoOQ79sxKd3zv1dT67K1GM36mQ=='
      expect(subject.encrypt_with_key(key, data)).to eq expected_ciphertext
    end
  end

  describe '#decrypt' do
    it 'can decrypt encrypted data' do
      ciphertext = 'FPXj2e2DZrFYRVUhqoBWXhVVVGUO2ZJgayU2F1f6duLtBjYOINvAZPWIXjIVHHslgg=='

      expect(subject.decrypt(password, ciphertext)).to eq data
    end
  end

  describe '#decrypt_with_key' do
    it 'can decrypt encrypted data' do
      ciphertext = 'YWFhYWFhYWFhYWFhzs8I/ks+nAy2V+Q7xIrJAnOHefyfO4zYwwmz1F2y1mf1wfXDqA=='

      expect(subject.decrypt_with_key(key, ciphertext)).to eq data
    end
  end
end
