class StaticPagesController < ApplicationController
  def home
  	if logged_in?
  		@micropost = current_user.microposts.build
  		@feed_items = current_user.feed(current_user).paginate(page: params[:page]).search(params[:q])
  	end
  end

  def help
  end

  def about
  end

  def contact
  end
end
