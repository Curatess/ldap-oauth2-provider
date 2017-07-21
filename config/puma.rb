min_threads = Integer(ENV['MIN_THREADS'] || 2)
max_threads = Integer(ENV['MAX_THREADS'] || 4)

threads     min_threads, max_threads
environment ENV['RACK_ENV'] || 'development'
activate_control_app
# state_path 'tmp/puma.state'

if ENV['WEB_CONCURRENCY'].to_i > 1
  workers ENV['WEB_CONCURRENCY']
  preload_app!

 on_worker_boot do
    # Valid on Rails 4.1+ using the `config/database.yml` method of setting `pool` size
    # https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server#on-worker-boot
    ActiveRecord::Base.establish_connection
    ActiveRecord::Base.connection.execute('set statement_timeout to 10000')
  end
end

# on_restart do
#   Sidekiq.redis.shutdown { |conn| conn.close }
# end

bind 'tcp://0.0.0.0:80'
bind 'ssl://0.0.0.0:443?key=/etc/letsencrypt/live/placeholderdomain/privkey.pem&cert=/etc/letsencrypt/live/placeholderdomain/fullchain.pem'
