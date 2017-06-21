class Micropost < ApplicationRecord
  belongs_to :user

  scope :sort_feed, ->{order created_at: :desc}

  mount_uploader :picture, PictureUploader

  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: Settings.micropost.content_max}
  validate :picture_size

  private

  def picture_size
    if picture.size > Settings.micropost.picture_size.megabytes
      errors.add :picture, t(".pic_max_5mb")
    end
  end
end
