class User < ApplicationRecord
  attr_accessor :remember_token
  before_save {email.downcase!}

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i
  validates :name, presence: true, length: {maximum: Settings.user.max_name_size}

  validates :email, presence: true, length: {maximum: Settings.user.max_email_size},
    format: {with: VALID_EMAIL_REGEX}, uniqueness: {case_sensitive: false}

  has_secure_password
  validates :password, presence: true, length: {minimum: Settings.user.min_pass_size}

  class << self
    def User.digest string
      cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
        BCrypt::Engine.cost
      BCrypt::Password.create string, cost: cost
    end

    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  def remember
    self.remember_token = User.new_token
    update_attributes remember_digest: User.digest(remember_token)
  end

  def authenticated? remember_token
    BCrypt::Password.new(remember_digest).is_password? remember_token
  end

  def forget
    update_attributes remember_digest: nil
  end
end
