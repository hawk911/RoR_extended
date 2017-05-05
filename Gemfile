source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.0.0'
# Use postgresql as the database for Active Record
gem 'pg', '~> 0.18'
# Use Puma as the app server
gem 'puma', '~> 3.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0', '>= 5.0.6'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# See https://github.com/rails/execjs#readme for more supported runtimes
gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 3.0'
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# bootstrap
gem 'bootstrap-sass', '~> 3.3.6'
# jquery-turbolinks
# gem 'jquery-turbolinks'
#"responders"
gem "responders"
# devise
gem 'devise'
# slim
gem 'slim-rails'
# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

# Attach files
gem 'carrierwave'
# For attach file (AJAX style file uploads)
gem 'remotipart'
# Unobtrusive nested forms handling, using jQuery.
gem 'cocoon'
# Get your Rails variables in your js
gem 'gon'
# Client-side templates
gem 'skim'
# Omniauth
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
#cancancan
gem 'cancancan'
#doorkeeper
gem 'doorkeeper'
#serializers
gem 'active_model_serializers', '~> 0.10.0'
#the faster json
gem 'oj'
gem 'oj_mimic_json'
#sidekiq
gem 'sidekiq'
#sinatra for sidekiq
gem 'sinatra', git: 'https://github.com/sinatra/sinatra.git', require: nil
# whenever on cron
gem 'whenever'
# test
group :development, :test do
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug', platform: :mri
  gem 'capybara'
  gem 'capybara-webkit'
  gem 'capybara-email'
  gem 'database_cleaner'
  gem 'pry-rails'
  gem 'pry'
  gem 'pry-byebug'
  gem 'dotenv-rails'
  gem 'capybara-email'
  gem 'letter_opener'
end

# shoulda-matchers, capybara, controller testing
group :test do
  gem 'shoulda-matchers'
  gem 'launchy'
  gem 'rails-controller-testing'
  gem 'json_spec'
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console'
  gem 'listen', '~> 3.0.5'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'rubocop', require: false
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]
