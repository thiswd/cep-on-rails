class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  devise :database_authenticatable,
    :jwt_authenticatable, jwt_revocation_strategy: self

  validates :email, presence: true, uniqueness: true

  def for_display
    {
      id: id,
      email: email
    }
  end
end
