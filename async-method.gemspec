Gem::Specification.new do |s|
  s.name = "async-method"
  s.summary = "Make Active Record instance methods asynchronous using resque or sidekiq"
  s.description = "Make Active Record instance methods asynchronous using resque or sidekiq"
  s.files = Dir["lib/**/*"] + %w(MIT-LICENSE Rakefile README.md)
  s.version = "0.1"
  s.authors = ["Nisanth Chunduru"]
  s.email = "nisanth074@gmail.com"
  s.homepage = "http://github.com/SupportBee/async-method"

  s.add_dependency 'resque'
  s.add_dependency 'sidekiq'
  s.add_dependency 'activesupport'

  s.add_development_dependency 'sqlite3'
end
