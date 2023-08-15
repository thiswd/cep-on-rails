FactoryBot.define do
  factory(:user) do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    jti { SecureRandom.uuid }
  end
end
