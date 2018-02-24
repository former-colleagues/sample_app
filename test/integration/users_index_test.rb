require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  
  def setup
  	@admin = users(:michael)
  	@non_admin = users(:archer)
  end

  test "index as admin including pagination and delete links" do
  	# adminユーザーでログインする
  	log_in_as(@admin)
  	# users/indexのgetメソッドを取得する
  	get users_path
  	# 取得したページに遷移しているか確認する
  	assert_template 'users/index'
  	# paginationクラスが存在することを確認する
  	assert_select 'div.pagination', count: 2
  	# １ページ目のユーザーを取得する
  	first_page_of_users = User.paginate(page:1)
  	# １ページ目のユーザーについてループ処理を実行
  	first_page_of_users.each do |user|
  		# 各ユーザーについて、アンカーリンクとユーザー名のテキストがあることを確認
  		assert_select 'a[href=?]', user_path(user), text: user.name
  		# adminユーザー以外は、テキストにdeleteがあることを確認する
  		unless user == @admin
  			assert_select 'a[href=?]', user_path(user), text: 'delete'
  		end
  	end
  	# deleteリクエストを実行するとユーザーが1減ることを確認する
  	assert_difference 'User.count', -1 do
  		delete user_path(@non_admin)
  	end
  end

  test "index as non-admin" do
  	# 非adminユーザーでログインする
  	log_in_as(@non_admin)
  	# ユーザー一覧へ移動する
  	get users_path
  	# アンカーリンクにdeleteテキストがないことを確認する
  	assert_select 'a', text: 'delete', count: 0
  end
end
