Snmpjr
======

[![Gem Version](https://badge.fury.io/rb/snmpjr.svg)](http://badge.fury.io/rb/snmpjr) [![Build Status](https://travis-ci.org/zenonas/snmpjr.svg?branch=master)](https://travis-ci.org/zenonas/snmpjr) [![Coverage Status](https://img.shields.io/coveralls/zenonas/snmpjr.svg)](https://coveralls.io/r/zenonas/snmpjr?branch=master) [![Code Climate](https://codeclimate.com/github/zenonas/snmpjr/badges/gpa.svg)](https://codeclimate.com/github/zenonas/snmpjr) [![Dependency Status](https://gemnasium.com/zenonas/snmpjr.svg)](https://gemnasium.com/zenonas/snmpjr) [![Inline docs](http://inch-ci.org/github/zenonas/snmpjr.svg?branch=master)](http://inch-ci.org/github/zenonas/snmpjr)

Snmpjr aims to provide a clean and simple interface to use SNMP in your ruby code. It will wrap the popular SNMP4J library in Java.

Please note the gem is still in early develpment. Do not use as of yet!

## Features

* Simple Synchronous SNMP v2c Get requests

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
# Initialize Snmpjr with host, port and a community
snmp = Snmpjr.new(host: '127.0.0.1', port: 161, community: 'public')
Optional Params. (retries, timeout)

# Call get on any single Oid
snmp.get '1.3.6.1.2.1.1.1.0'
=> 'The result'

# Call get on an array of Oids'
snmp.get ['1.3.6.1.2.1.1.1.0', '1.3.6.1.2.1.1.3.0']
=> [Snmpjr::Response.new(value: 'First result'), Snmpjr::Response.new(value: 'Second result')]

Response objects respond to error?

# Call walk on an Oid
snmp.walk '1.3.6.1.2.1.1.1'
=> [Snmpjr::Response.new(value: 'First response')..Snmpjr::Response.new(value: 'First response')]
```

Snmpjr will catch and raise any exceptions that happen in Java land as RuntimeErrors preserving the message.

When you request an Array of Oids these will be pulled sequentially

## Contributing

1. Fork it ( https://github.com/zenonas/snmpjr/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
