source 'https://rubygems.org'
ruby '2.1.1'

gem 'bootstrap-sass'
gem 'coffee-rails'
gem 'rails', '4.1.1'
gem 'haml-rails'
gem 'sass-rails'
gem 'uglifier'
gem 'jquery-rails'
gem 'pg'

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
  gem 'database_cleaner', '1.2.0'
  gem 'capybara'
  gem 'launchy'
end

group :production do
  gem 'rails_12factor'
end



