require 'test_helper'

class AsyncMethodTest < ActiveSupport::TestCase
  test "define methods" do
    assert User.new.respond_to?(:long_method)
    assert User.new.respond_to?(:another_long_method)

    assert User.new.respond_to?(:sync_long_method)
    assert User.new.respond_to?(:sync_another_long_method)
  end

  test "enqueue jobs" do
    user = User.first

    sidekiq_job_id = user.long_method
    assert_equal String, sidekiq_job_id.class
    assert_equal 'success!', user.sync_long_method
  end

  test "raise error if not persisted" do
    user = User.new

    assert_raises(AsyncMethod::RecordNotPersistedError) do
      user.long_method
    end
  end

  # @todo Add test cases for Resque
end
