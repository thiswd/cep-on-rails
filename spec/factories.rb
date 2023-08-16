FactoryBot.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    jti { SecureRandom.uuid }
  end

  factory :address_response, class: Hash do
    cep { '01001-000' }
    logradouro { 'Praça da Sé' }
    complemento { 'lado ímpar' }
    bairro { 'Sé' }
    localidade { 'São Paulo' }
    uf { 'SP' }
    ibge { '3550308' }
    gia { '1004' }
    ddd { '11' }
    siafi { '7107' }

    initialize_with { attributes }
  end
end
