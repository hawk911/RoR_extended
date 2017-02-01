class User < ApplicationRecord
  before_create :skip_confirmation!
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
    :recoverable, :rememberable, :trackable, :validatable, :confirmable,
    :omniauthable, omniauth_providers: [:facebook, :twitter]
  has_many :questions
  has_many :answers
  has_many :authorizations, dependent: :destroy

  def author_of?(object)
    object.user_id == id
  end

  def voted?(object)
    object.votes.where(user: self).exists?
  end

  def can_vote?(object)
    !author_of?(object) && !voted?(object)
  end

  def self.find_for_oauth(auth)
    return nil if (auth.blank? || auth.provider.blank? || auth.uid.blank?)

    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    if auth.info[:email].present?
      email = auth.info[:email]
      user = User.where(email: email).first
    else
      email = random_email
      confirmation_required = true
    end

    unless user
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password)
      user.update!(confirmed_at: nil) if confirmation_required
    end

    user.create_authorization(auth)
    user

  end

  def create_authorization(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end

  def last_authorization_twitter?
    (authorizations.any? && authorizations.last.provider == 'twitter') ? true : false
  end

  def self.random_email
    "#{SecureRandom.hex(15)}@example.com"
  end
end
