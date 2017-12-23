# Configure Sidekiq to run the job immediately upon enqueue
# @see https://github.com/mperham/sidekiq/wiki/Testing
require 'sidekiq/testing'
Sidekiq::Testing.inline!
