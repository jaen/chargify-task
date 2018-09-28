source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

# Bundle edge Rails instead: gem "rails", github: "rails/rails"
gem "rails", "~> 5.1.5"
# Use sqlite3 as the database for Active Record
gem "sqlite3"
# Use Puma as the app server
gem "puma", "~> 3.7"
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
# gem "jbuilder", "~> 2.5"
# Use ActiveModel has_secure_password
# gem "bcrypt", "~> 3.1.7"

# Use Capistrano for deployment
# gem "capistrano-rails", group: :development

# Use Rack CORS for handling Cross-Origin Resource Sharing (CORS), making cross-origin AJAX possible
# gem "rack-cors"

#
gem "dry-struct", "0.5.1"
gem "money", "~> 6.12.0"
gem "monetize", "~> 1.9.0"
gem "http", "~> 3.3.0"

group :development, :test do
  gem "rspec", "~> 3.8"
  gem "rspec-rails", "~> 3.8"
  gem "guard", "~> 2.14.2"
  gem "guard-rspec", "~> 4.7.3"

  # Call "byebug" anywhere in the code to stop execution and get a debugger console
  gem "byebug", :platforms => [:mri, :mingw, :x64_mingw]
  gem "better_errors"
  gem "pry-byebug"
  gem "pry-rails"
  gem "binding_of_caller"
end

group :development do
  gem "listen", ">= 3.0.5", "< 3.2"
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "tzinfo-data", :platforms => [:mingw, :mswin, :x64_mingw, :jruby]
