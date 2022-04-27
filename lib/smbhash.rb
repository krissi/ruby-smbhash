require 'openssl'

module Smbhash
  module_function
  def lm_hash(password, encoding=nil)
    dos_password = Private.convert_encoding("ISO-8859-1",
                                            encoding || "UTF-8",
                                            password.upcase)
    fail ArgumentError, 'Password must be < 14 characters in ISO-8859-1' if dos_password.size > 14

    Private.encrypt_14characters(dos_password).unpack("C*").collect do |char|
      "%02X" % char
    end.join
  end

  def ntlm_hash(password, encoding=nil)
    ucs2_password = Private.convert_encoding("UTF-16LE",
                                             encoding || "UTF-8",
                                             password)

    fail ArgumentError, 'Password must be < 255 characters in UTF-16LE' if ucs2_password.size > 255

    hex = OpenSSL::Digest::MD4.new(ucs2_password).hexdigest.upcase
    hex
  end

  def ntlmgen(password, encoding=nil)    
    [
      lm_hash(password, encoding),
      ntlm_hash(password, encoding)
    ]
  end

  module Private
    module_function

    case RUBY_VERSION
    when /^1\.9/, /^2/, /^3\.1/
      require "smbhash/methods19"
      extend Methods19
    when /^1\.8/
      require "smbhash/methods18"
      extend Methods18
    else
      raise NotImplementedError, "Ruby #{RUBY_VERSION} is not supported"
    end

    def normalize_encoding(encoding)
      encoding.downcase.gsub(/-/, "_")
    end

    def same_encoding?(a, b)
      na = normalize_encoding(a)
      nb = normalize_encoding(b)
      na == nb or na.gsub(/_/, '') == nb.gsub(/_/, '')
    end

    def des_crypt56(input, key_str, forward_only)
      key = str_to_key(key_str)
      encoder = OpenSSL::Cipher::DES.new
      encoder.encrypt
      encoder.key = key
      encoder.update(input)
    end

    LM_MAGIC = "KGS!@\#$%"
    def encrypt_14characters(chars)
      raise ArgumentError.new("must be <= 14 characters") if chars.size > 14
      chars = chars.to_s.ljust(14, "\000")
      des_crypt56(LM_MAGIC, chars[0, 7], true) +
          des_crypt56(LM_MAGIC, chars[7, 7], true)
    end
  end
end
