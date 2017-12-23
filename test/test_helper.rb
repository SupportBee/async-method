# Configure Rails Environment
ENV["RAILS_ENV"] = "async_testing"

require "pry"
require File.expand_path("../rails_app_with_sidekiq/config/environment.rb",  __FILE__)
require "rails/test_help"

Rails.backtrace_cleaner.remove_silencers!

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

class ActiveSupport::TestCase
  fixtures :all
end
