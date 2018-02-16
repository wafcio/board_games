class User < ApplicationRecord
  has_many :authentications
  has_many :emails

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :multi_email_authenticatable, :multi_email_confirmable,
         :multi_email_validatable, :omniauthable, :registerable, :recoverable,
         :rememberable, :trackable,
         omniauth_providers: %i(facebook google_oauth2 linkedin)
end
