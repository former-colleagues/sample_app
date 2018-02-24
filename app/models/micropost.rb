class Micropost < ApplicationRecord
  belongs_to :user
  default_scope -> { order(created_at: :desc) }
  scope :including_replies, ->(user){ where("in_reply_to = ? OR in_reply_to = ? OR user_id = ?", "", "@#{user.id}\-#{user.name.sub(/\s/,'-')}", user.id) }
  mount_uploader :picture, PictureUploader
  validates :user_id, presence: true
  validates :content, presence:true, length: { maximum: 140 }
  validate :picture_size
  before_save { self.in_reply_to = reply_user.to_s }

  def Micropost.search(query)
    if query
      where('content LIKE(?)', "%#{query}%")
    else
      all
    end
  end

  # def self.including_replies(following_ids)
  # end

  def reply_user
    if user_unique_name = content.match(/(@\S+)\s.*/)
      user_unique_name[1]
    end
  end

  private

  	# アップロードされた画像のサイズをバリデーションする
  	def picture_size
  		if picture.size > 5.megabytes
  			errors.add(:picture, "should be less than 5MB")
  		end
  	end
end
