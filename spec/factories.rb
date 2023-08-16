FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    jti { SecureRandom.uuid }
  end

  factory :address do
    association :user
    cep { "12345678" }
    street_name { "Some Street" }
    complement { "Some Complement" }
    neighborhood { "Some Neighborhood" }
    city { "Some City" }
    state { "Some State" }
  end

  factory :address_response, class: Hash do
    cep { "01001-000" }
    logradouro { "Praça da Sé" }
    complemento { "lado ímpar" }
    bairro { "Sé" }
    localidade { "São Paulo" }
    uf { "SP" }
    ibge { "3550308" }
    gia { "1004" }
    ddd { "11" }
    siafi { "7107" }

    initialize_with { attributes }
  end
end
