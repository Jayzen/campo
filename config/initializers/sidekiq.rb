Sidekiq.configure_server do |config|
  #config.redis = { url: "redis://localhost:6379/0" }
  config.redis = { url: ENV['REDIS_URL'] }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV['REDIS_URL'] }
  #config.redis = { url: "redis://localhost:6379/0" }
end