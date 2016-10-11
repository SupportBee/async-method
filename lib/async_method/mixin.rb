require "active_support/dependencies"
require "async_method/worker"

module AsyncMethod
  module Mixin
    extend ActiveSupport::Concern

    class NotPersistedError < StandardError; end

    module ClassMethods
      def async_method(method_name, options = {})
        # Allow tests to call sync_ methods ...
        alias_method :"sync_#{method_name}", method_name

        # ... but don't actually make them asynchronous
        return if Rails.env.test?

        define_method "#{method_name}" do |*args|
          raise NotPersistedError, "Methods can only be async'ed on persisted records (currently: #{inspect})" unless persisted?

          queue = options[:queue] || send(:class).name.underscore.pluralize

          if AsyncMethod.queue_jobs_with.to_s == "sidekiq"
            adapter = Sidekiq::Client
          else
            adapter = Resque
          end
          adapter.enqueue_to(
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
