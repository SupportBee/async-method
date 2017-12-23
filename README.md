async-method
==============================

Make Active Record instance methods asynchronous using [sidekiq](https://github.com/mperham/sidekiq) or [resque](http://www.github.com/defunkt/resque)

Usage
-----

Create an initializer `config/initializers/async_method.rb` and specify the background job processing system you use

```ruby
# config/initializers/async_method.rb

AsyncMethod.queue_jobs_with = :sidekiq

# or if your rails app uses resque

AsyncMethod.queue_jobs_with = :resque
```

```ruby
class User < ActiveRecord::Base
  def send_welcome_email
    # This is a method that takes a long time to run
  end
  async_method :send_welcome_email, queue: 'emails'
end

user = User.find(1)
user.send_welcome_email # => Queued in the 'emails' queue
user.sync_send_welcome_email # => Happens right away!
```


Todo
---------

* Publish the gem in rubygems.org