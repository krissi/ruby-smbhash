require 'spec_helper'
require 'smbhash'

describe Smbhash do
  describe '.lm_hash' do
    it 'returns a valid lanman hash' do
      expect(Smbhash.lm_hash("password")).to        eq("E52CAC67419A9A224A3B108F3FA6CB6D")
      expect(Smbhash.lm_hash("paSSWOrd")).to        eq("E52CAC67419A9A224A3B108F3FA6CB6D")
      expect(Smbhash.lm_hash("abcdefgabcdefg")).to  eq("E0C510199CC66ABDE0C510199CC66ABD")
      expect(Smbhash.lm_hash("SecREt01")).to        eq("FF3750BCC2B22412C2265B23734E0DAC")
    end

    context 'when more than 14 chars are given as password' do
      it 'raises an ArgumentError' do
        expect { Smbhash.lm_hash('X' * 15) }.to raise_error(ArgumentError, /14 characters/)
      end
    end
  end

  describe '.ntlm_hash' do
    it 'returns a valid ntlm hash' do
      expect(Smbhash.ntlm_hash("password")).to    eq("8846F7EAEE8FB117AD06BDD830B7586C")
    end

    context 'when more than 255 chars are given as password' do
      it 'raises an ArgumentError' do
        expect { Smbhash.ntlm_hash('X' * 256) }.to raise_error(ArgumentError, /255 characters/)
      end
    end
  end

  describe '.ntlmgen' do
    it 'returns the output of .lm_hash and .htlm_hash as array' do
      expect(Smbhash).to receive(:lm_hash).with("password", anything())
      expect(Smbhash).to receive(:ntlm_hash).with("password", anything())
      Smbhash.ntlmgen("password")
    end
  end
end
