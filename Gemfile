source 'https://rubygems.org'
ruby '2.0.0'
#ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'
gem 'sidekiq'
gem 'rack-timeout'
gem 'sentry-raven' #, :github => "getsentry/raven-ruby"
gem 'carrierwave'
gem "mini_magick"
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'
gem 'figaro'
#--->
#gem 'fog-aws'
gem 'carrierwave-aws'
#--->
gem 'draper'
#--->
gem 'stripe_event'

group :production do
  gem 'rails_12factor'
  #-->
  gem 'unicorn'
  #-->
end

group :secure do
  # the OpenBSD bcrypt() password hashing algorithm
  # to perform one way hash
  #gem 'bcrypt-ruby', '~> 3.0.0' #for rails 4.0.0
  gem 'bcrypt-ruby'

end

group :development do
  gem 'thin'
  gem "better_errors"
  gem "binding_of_caller"
  gem 'letter_opener'
end

group :development, :test do
  gem 'fabrication'
  gem 'faker'
  gem 'pry'
  gem 'pry-nav'
  gem 'rspec-rails', '2.99'
end

group :test do
  gem 'shoulda-matchers'
  #gem 'database_cleaner', '1.2.0' #truncate all the records in testing database
  gem 'database_cleaner'
  gem 'capybara'
  gem 'launchy'
  gem 'capybara-email'
  gem 'vcr'
  gem 'webmock'
  gem 'selenium-webdriver'
  gem 'capybara-webkit'
end


