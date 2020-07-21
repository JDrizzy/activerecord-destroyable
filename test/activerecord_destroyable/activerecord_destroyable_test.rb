# frozen_string_literal: true

require 'test_helper'

class ActiverecordDestroyable::ActiverecordDestroyableTest < ActiveSupport::TestCase
  test 'destroy? raises error' do
    user = users(:user_one)
    refute user.destroy?
    assert_equal 'Cannot delete record because dependent comments exist', user.errors.full_messages.to_sentence
  end

  test 'destroy? passes' do
    user = users(:user_two)
    assert user.destroy?
  end
end
