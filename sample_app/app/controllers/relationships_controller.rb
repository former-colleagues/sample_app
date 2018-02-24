class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		# 新規フォロワー増加時に通知する(フォローされるユーザーのnotificationがfalseの場合は送信しない)
		current_user.send_increase_follower_notification(@user) if @user.notification
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end

	def destroy
		# Relationshipのfollowed_idの人を返す
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		respond_to do |format|
			format.html { redirect_to @user }
			format.js
		end
	end
end
