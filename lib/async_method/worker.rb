module AsyncMethod
  class Worker
    include Sidekiq::Worker if const_defined?("::Sidekiq::Worker")

    def self.perform(*args)
      new.perform(*args)
    end

    def perform(klass, *args)
      klass.constantize.find(args.shift).send(args.shift, *args)
    end
  end
end
