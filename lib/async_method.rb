require "async_method/mixin"

module AsyncMethod
  class << self
    attr_accessor :queue_jobs_with
  end
end

ActiveSupport.on_load(:active_record) do
  include AsyncMethod::Mixin
end
