require 'openssl'

module Samba
  module Encrypt
    module_function
    def lm_hash(password, encoding=nil)
      dos_password = Private.convert_encoding("ISO-8859-1",
                                              encoding || "UTF-8",
                                              password.upcase)
      if dos_password.size > 14
        warn("password is truncated to 14 characters")
        dos_password = dos_password[0, 14]
      end
      Private.encrypt_14characters(dos_password).unpack("C*").collect do |char|
        "%02X" % char
      end.join
    end

    def ntlm_hash(password, encoding=nil)
      ucs2_password = Private.convert_encoding("UCS-2",
                                               encoding || "UTF-8",
                                               password)
      if ucs2_password.size > 256
        raise ArgumentError.new("must be <= 256 characters in UCS-2")
      end
      hex = OpenSSL::Digest::MD4.new(ucs2_password).hexdigest.upcase
      hex
    end

    module Private
      module_function
      def convert_encoding(to, from, str)
        if same_encoding?(to, from)
          str
        else
          require 'iconv'
          Iconv.iconv(to, from, str).join
        end
      end

      def normalize_encoding(encoding)
        encoding.downcase.gsub(/-/, "_")
      end

      def same_encoding?(a, b)
        na = normalize_encoding(a)
        nb = normalize_encoding(b)
        na == nb or na.gsub(/_/, '') == nb.gsub(/_/, '')
      end

      def str_to_key(str)
        key = "\000" * 8
        key.setbyte(0,  str.getbyte(0) >> 1);
        key.setbyte(1,  ((str.getbyte(0) & 0x01) << 6) | (str.getbyte(1) >> 2));
        key.setbyte(2,  ((str.getbyte(1) & 0x03) << 5) | (str.getbyte(2) >> 3));
        key.setbyte(3,  ((str.getbyte(2) & 0x07) << 4) | (str.getbyte(3) >> 4));
        key.setbyte(4,  ((str.getbyte(3) & 0x0F) << 3) | (str.getbyte(4) >> 5));
        key.setbyte(5,  ((str.getbyte(4) & 0x1F) << 2) | (str.getbyte(5) >> 6));
        key.setbyte(6,  ((str.getbyte(5) & 0x3F) << 1) | (str.getbyte(6) >> 7));
        key.setbyte(7,  str.getbyte(6) & 0x7F);

        key.size.times do |i|
          key.setbyte(i, (key.getbyte(i) << 1));
        end

        key
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
end