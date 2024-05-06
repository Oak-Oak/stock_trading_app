IEX::Api.configure do |config|
  config.publishable_token = 'pk_7ebdbe7189304add85d5f3d8a033a1db' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
  config.secret_token = 'sk_5c11cc66d27048de86b719f10219635e' # defaults to ENV['IEX_API_SECRET_TOKEN']
  config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end