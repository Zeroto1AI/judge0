redis_options = {
  host:     ENV["REDIS_HOST"],
  port:     ENV["REDIS_PORT"],
  password: ENV["REDIS_PASSWORD"],
  thread_safe: true
}

if ENV["REDIS_TLS"] == "true"
  require "openssl"

  redis_options[:ssl] = true
  redis_options[:ssl_params] = {
    verify_mode: OpenSSL::SSL::VERIFY_PEER,
    verify_hostname: true
  }
  redis_options[:ssl_params][:ca_file] = ENV["REDIS_SSL_CA_FILE"] if ENV["REDIS_SSL_CA_FILE"].present?
end

Resque.redis = Redis.new(redis_options)

if ENV["RESQUE_NAMESPACE"].present?
  Resque.redis.namespace = ENV["RESQUE_NAMESPACE"].to_sym
end
