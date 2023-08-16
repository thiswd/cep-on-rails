class Address < ApplicationRecord
  belongs_to :user

  validates :cep, uniqueness: { scope: :user_id, message: I18n.t("errors.duplicate_address_error") }
  validates :cep, :street_name, :complement, :neighborhood, :city, :state, presence: true
end
