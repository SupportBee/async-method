require "active_support/dependencies"
require "async_method/worker"

module AsyncMethod
  class RecordNotPersistedError < StandardError; end

  # Active record mixin
  module Mixin
    extend ActiveSupport::Concern

    module ClassMethods
      def async_method(method_name, options = {})
        # Allow tests to call sync_ methods ...
        alias_method :"sync_#{method_name}", method_name

        # ... but don't actually make them asynchronous
        return if Rails.env.test?

        define_method "#{method_name}" do |*args|
          raise AsyncMethod::RecordNotPersistedError, "Methods can only be async'ed on persisted records (currently: #{inspect})" unless persisted?
          unless %w(sidekiq resque).include?(AsyncMethod.queue_jobs_with.to_s)
            error_message = <<-ERROR_MESSAGE
You must tell async-method which queuing system ("sidekiq" or "resque") you use in an initializer

  # In config/initializers/async_method.rb
  AsyncMethod.queue_jobs_with = "sidekiq"
ERROR_MESSAGE
            raise StandardError.new(error_message)
          end
          if AsyncMethod.queue_jobs_with == "sidekiq" && !Module.const_defined?("Sidekiq")
            error_message = <<-ERROR_MESSAGE
You must add the "sidekiq" gem before the "async-method" gem in your Gemfile
ERROR_MESSAGE
            raise StandardError.new(error_message)
          elsif AsyncMethod.queue_jobs_with == "resque" && !Module.const_defined?("Resque")
            error_message = <<-ERROR_MESSAGE
You must add the "resque" gem before the "async-method" gem in your Gemfile
ERROR_MESSAGE
            raise StandardError.new(error_message)
          end

          queue = options[:queue] || send(:class).name.underscore.pluralize
          enqueuer = if AsyncMethod.queue_jobs_with.to_s == "sidekiq"
            "Sidekiq::Client"
          else
            "Resque"
          end
          enqueuer.constantize.enqueue_to(
            queue,
            AsyncMethod::Worker,
            send(:class).name,
            send(:id),
            :"sync_#{method_name}",
            *args
          )
        end
      end
    end
  end
end
