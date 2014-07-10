require 'bundler/setup'
Bundler.require

#helpers Sinatra::Jsonp

not_found do
  redirect to 'https://krissi.github.io/ruby-smbhash/'
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

get '/wake_up' do
  ''
end
