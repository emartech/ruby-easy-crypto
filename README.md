# EasyCrypto [![Build Status](https://travis-ci.org/emartech/ruby-easy-crypto.svg?branch=master)](https://travis-ci.org/emartech/ruby-easy-crypto) [![Gem Version](https://badge.fury.io/rb/easy-crypto.svg)](https://badge.fury.io/rb/easy-crypto)

Provides simple wrappers around the openssl crypto implementation. The library provides two interfaces: simple and advanced. Simple mode is designed for ease-of-use and advanced mode provides some performance benefits in certain use-cases. See below for more details.

All the underlying crypto operations are the same.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy-crypto'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy-crypto

## Simple usage (Recommended)

```ruby
require 'easycrypto'

password = 'secret password'
plaintext = 'some data'

ecrypto = EasyCrypto::Crypto.new

encrypted = ecrypto.encrypt(password, plaintext)
decrypted = ecrypto.encrypt(password, encrypted)

decrypted == plaintext
```

## Advanced usage (Use for performance)

[Key derivation](https://en.wikipedia.org/wiki/Key_derivation_function) is a resource heavy process. The simple interface abstracts this away and forces you to recompute the key before each encryption/decryption process.

This interface allows you to cache the result of the key derivation. This is required if you need to encrypt/decrypt multiple times with the same derived key. Caching the key saves you the time to have to recompute it before every encryption/decryption.

```ruby
require 'easycrypto'

password = 'secret password'
plaintext = 'data to encrypt ...'

ecrypto = EasyCrypto::Crypto.new

key = EasyCrypto::Key.generate(key_password)

encrypted = ecrypto.encrypt_with_key(key, plaintext)
decrypted = ecrypto.decrypt_with_key(key, encrypted)

decrypted == plaintext
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
