require 'bundler/setup'
Bundler.require

#helpers Sinatra::Jsonp

get '/' do
  'hi'
end

get '/hash/:password' do
  password = params.fetch('password')
  callback = params.fetch('callback') { :update_result }

  result = [ :lm_hash, :ntlm_hash ].inject({}) do |result, hash_type|
    result[hash_type] = Smbhash.public_send(hash_type, password)
    result
  end

  jsonp(result, callback.to_sym)
end

