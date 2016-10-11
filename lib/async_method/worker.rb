module AsyncMethod
  class Worker
    include Sidekiq::Worker
    
    def self.perform(klass, *args)
      new.perform(klass, *args)
    end

    def perform(klass, *args)
      klass.constantize.find(args.shift).send(args.shift, *args)
    end
  end
end