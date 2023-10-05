FactoryBot.define do
  factory :user do
    name { Faker::Internet.name }
    username { Faker::Internet.username }
    email { Faker::Internet.email }
    password { "Password@123"}
  end
end
