source "http://rubygems.org"

gemspec

gem 'rails', '~> 3.1'
# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'

# Older json gem versions cause `bundle install` to fail
# @see http://fuzzyblog.io/blog/ruby/2016/10/11/what-to-do-when-bundle-install-fails-with-json-1-8-1.html
gem 'json', ">= 1.8.3"

gem 'sidekiq', :require => false
gem 'resque', :require => false

if RUBY_VERSION < '1.9'
  gem "ruby-debug", ">= 0.10.3"
end
