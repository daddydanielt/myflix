Fabricator(:user) do
  email { Faker::Internet.email }
  password { Faker::Internet.password }
  full_name { Faker::Name.name }
end