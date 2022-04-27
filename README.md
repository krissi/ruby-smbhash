# ruby-smbhash
[![Build Status](https://travis-ci.org/krissi/ruby-smbhash.svg?branch=master)](https://travis-ci.org/krissi/ruby-smbhash)
[![Gem Version](https://badge.fury.io/rb/smbhash.svg)](http://badge.fury.io/rb/smbhash)

## Description
ruby-smbhash is a implementation of lanman and nt md4 hash functions for use in Samba style smbpasswd entries. It was stripped from ActiveSambaLDAP (http://asl.rubyforge.org/activesambaldap/)

## Tested Ruby Versions
  * MRI 1.8.6
  * MRI 1.9.2
  * MRI 1.9.3
  * MRI 2.0.0
  * MRI 2.1.1
  * MRI 3.1.2

## Usage
    require 'smbhash'

    Smbhash.lm_hash    "password"
    # => "E52CAC67419A9A224A3B108F3FA6CB6D"

    Smbhash.ntlm_hash  "password"
    # => "8846F7EAEE8FB117AD06BDD830B7586C"

    Smbhash.ntlmgen    "password"
    # => ["E52CAC67419A9A224A3B108F3FA6CB6D", "8846F7EAEE8FB117AD06BDD830B7586C"]

## Credits
  * ActiveSambaLDAP project for sharing the code
  * jon-mercer for porting it to ruby 1.9

