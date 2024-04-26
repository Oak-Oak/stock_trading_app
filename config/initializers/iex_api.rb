IEX::Api.configure do |config|
  config.publishable_token = 'pk_0553f5c0b81949e9b83f478b23aba19f' # defaults to ENV['IEX_API_PUBLISHABLE_TOKEN']
  config.secret_token = 'sk_7b7a869cf03045a08e218763e413ddd0' # defaults to ENV['IEX_API_SECRET_TOKEN']
  config.endpoint = 'https://cloud.iexapis.com/v1' # use 'https://sandbox.iexapis.com/v1' for Sandbox
end