Snmpjr
======

[![Gem Version](https://badge.fury.io/rb/snmpjr.svg)](http://badge.fury.io/rb/snmpjr) [![Build Status](https://travis-ci.org/zenonas/snmpjr.svg?branch=master)](https://travis-ci.org/zenonas/snmpjr) [![Coverage Status](https://img.shields.io/coveralls/zenonas/snmpjr.svg)](https://coveralls.io/r/zenonas/snmpjr?branch=master) [![Code Climate](https://codeclimate.com/github/zenonas/snmpjr/badges/gpa.svg)](https://codeclimate.com/github/zenonas/snmpjr) [![Dependency Status](https://gemnasium.com/zenonas/snmpjr.svg)](https://gemnasium.com/zenonas/snmpjr) [![Inline docs](http://inch-ci.org/github/zenonas/snmpjr.svg?branch=master)](http://inch-ci.org/github/zenonas/snmpjr)

Snmpjr aims to provide a clean and simple interface to use SNMP in your ruby code. It wraps the popular SNMP4J library in Java.

## Features

* Synchronous SNMP Get and Walk for SNMPv2c and SNMPv3
* Simple API

## Requirements

* Java 1.6+
* JRuby 1.7+

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'snmpjr'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install snmpjr

## Usage

```ruby
# Initialize Snmpjr with the version of SNMP you want to work with
snmp = Snmpjr.new(Snmpjr::Version::V2C).configure do |config|
  config.host = 'example.com'
  config.community = 'public'
  # Optional Parameters
  config.port = 161 #(default)
  config.retries = 0 #(default)
  config.timeout = 5000 #(default)
  config.max_oids_per_request = 20 #(default)
end

snmp = Snmpjr.new(Snmpjr::Version::V3).configure do |config|
  config.host = 'example.com'
  config.user = 'some user'
  # Agent dependent options
  config.authentication 'authentication_protocol*', 'passphrase'
  config.privacy 'privacy_protocol**', 'passphrase'
  config.context = '' #(default)
  # Optional Parameters
  config.port = 161 #(default)
  config.retries = 0 #(default)
  config.timeout = 5000 #(default)
  config.max_oids_per_request = 20 #(default)
end

# There is no need to specify options that you wish to default
# * Authentication Protocols (SHA|MD5)
# ** Privacy Protocols (DES|3DES|AES128|AES192|AES256)

# Call get on any single Oid
snmp.get '1.3.6.1.2.1.1.1.0'
=> 'The result'

# Call get on an array of Oids'
snmp.get ['1.3.6.1.2.1.1.1.0', '1.3.6.1.2.1.1.3.0']
=> [Snmpjr::Response.new(value: 'First result'), Snmpjr::Response.new(value: 'Second result')]

# Response objects respond to response.error? that returns true if an SNMP error occured eg. noSuchInstance

# Call walk on an Oid
snmp.walk '1.3.6.1.2.1.1.1'
=> [Snmpjr::Response.new(value: 'First response')..Snmpjr::Response.new(value: 'Last response')]
```

Snmpjr will catch and raise any exceptions that happen in Java land and raise them as RuntimeErrors while preserving the message.

When you request an Array of Oids these will be packaged in a single PDU up to a maximum(configurable).

## Contributing

1. Fork it ( https://github.com/zenonas/snmpjr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
