uri = URI.parse(ENV["REDISCLOUD_URL"])

Resque.redis = Redis.new(host: uri.host, port: uri.port, password: uri.password, thread_safe: true) 

Dir["/app/models/ripple/payment_worker.rb"].each { |file| require file }
