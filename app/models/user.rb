class User < ApplicationRecord

  before_save {email.downcase!}
  validates :name, presence: true, length: {maximum: Settings.user.max_name_size}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

  validates :email, presence: true, length: {maximum: Settings.user.max_email_size},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  validates :password, presence: true, length: {minimum: Settings.user.min_pass_size}
  has_secure_password

end
