class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable, :rememberable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true, uniqueness: true

  has_many :addresses, dependent: :destroy

  def for_display
    {
      id:,
      email:
    }
  end
end
