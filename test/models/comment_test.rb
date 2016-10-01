require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test 'should not save comment without required attributes' do
    c = Comment.new
    assert_not c.save
  end

  test 'should not perm edit for not owner' do
    assert_not Comment.find_by_user_id(2).perm_edit?(User.find(1))
  end

  test 'should not perm edit by time' do
    comment = Comment.find_by_user_id(2)
    comment.created_at = Time.now - APP_CONFIG.comment_edit_time.minutes

    assert_not comment.perm_edit?(User.find(2))
  end

  test 'should have perm for edit' do
    assert Comment.find_by_user_id(1).perm_edit?(User.find(1))

    Devise::TestHelpers
  end
end
