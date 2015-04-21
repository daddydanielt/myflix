Fabricator(:video) do
  unless category || category_id
    category_id { Fabricate(:category).id }
  end
  title { Faker::Lorem.words(5).join(" ") }
  description { Faker::Lorem.paragraph(20) }
end