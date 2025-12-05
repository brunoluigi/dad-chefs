class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # Note: :validatable removed because it requires password validations
  # which conflict with magic-link-only authentication
  devise :magic_link_authenticatable, :registerable, :rememberable

  has_many :cookbooks
  has_many :recipes, through: :cookbooks
  has_many :chats, dependent: :destroy

  # Custom email validation since we removed :validatable
  validates :email, presence: true, uniqueness: { case_sensitive: false },
                    format: { with: Devise.email_regexp }
end
