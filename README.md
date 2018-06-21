# EasyCrypto [![Build Status](https://travis-ci.org/emartech/ruby-easy-crypto.svg?branch=master)](https://travis-ci.org/emartech/ruby-easy-crypto)

Provides simple wrappers around the openssl crypto implementation. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'easy-crypto'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install easy-crypto

## Usage

### Encrypt with previously derived key

```ruby
require 'easycrypto'

key_password = 'secret password'
plain_text = 'data to encrypt ...'

ecrypto = EasyCrypto::Crypto.new

key = EasyCrypto::Key.generate(key_password)
ecrypto.encrypt_with_key(key, plain_text)
```

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
