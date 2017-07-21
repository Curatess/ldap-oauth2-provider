source 'https://rubygems.org'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.2'
# Use postgresql as the database for Active Record
# gem 'pg', '~> 0.18'
gem 'sqlite3', '~> 1.3.11'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem 'jbuilder', '~> 2.5'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
gem 'rack-cors'

# Grape With Swagger For Documentation

gem 'redis', '~>3.2'
gem 'sidekiq', '~>5.0'
gem 'sidekiq-client-cli'

gem 'grape', '~> 0.19.2'

gem 'grape-jsonapi-resources'
gem 'jsonapi-resources', '~> 0.9.0'

gem 'grape-swagger', '~> 0.27.0'
gem 'grape-swagger-entity', '~> 0.2.0'
gem 'grape-swagger-representable', '~> 0.1.4'

gem 'hashie-forbidden_attributes'

gem 'net-ldap', '~> 0.16.0'

gem 'jwt', '~> 1.5.6'

gem 'rack-attack', '~> 5.0.1'

gem 'acme-client'

gem 'whenever', '~> 0.9.4'

gem 'rack-ssl-enforcer'

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'rspec-rails'
  gem 'pry-byebug'
end

group :development do
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'pry-rails'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
