#ex-1
#Fabricator(:category) do
#  videos(count: 3) { |attrs, i| Fabricate(:video, title: "video_title_#{i}", description: "video_description_#{i}") }
#  title { "title-default" }
#end

Fabricator(:category) do
  title { Faker::Lorem.words(5).join(" ") }
end