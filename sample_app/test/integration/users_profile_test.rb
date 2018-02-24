require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
  	@user = users(:michael)
  end

  # homeの確認テストここでいいのかな
  test "count relationships" do
    log_in_as(@user)
    get root_path
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
  end

  test "profile display" do
  	get user_path(@user)
  	assert_template 'users/show'
  	assert_select 'title', full_title(@user.name)
  	assert_select 'h1', text: @user.name
  	assert_select 'h1 >img.gravatar'
  	assert_select 'div.pagination', count: 1
  	assert_match @user.microposts.count.to_s, response.body
  	assert_select 'div.pagination'
    assert_match @user.active_relationships.count.to_s, response.body
    assert_match @user.passive_relationships.count.to_s, response.body
  	@user.microposts.paginate(page: 1).each do |micropost|
  		assert_match micropost.content, response.body
  	end
  end
end
