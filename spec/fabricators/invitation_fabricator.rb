Fabricator(:invitation) do
  #list_order { Faker::Lorem.words(5).join(" ") }
  recipient_name { Faker::Name.name}
  recipient_email { Faker::Internet.email }
  invitation_message {Faker::Lorem.paragraph(2)}
end