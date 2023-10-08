FactoryBot.define do
  factory :user do
    name { Faker::Name.name } # Agregar un valor aleatorio para el nombre
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "Password@123" }
  end
end
