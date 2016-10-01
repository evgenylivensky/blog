require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'should not save comment without required attributes' do
    c = Comment.new
    assert_not c.save
  end
end
