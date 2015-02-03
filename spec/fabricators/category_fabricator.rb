Fabricator(:category) do  
  videos(count: 3) { |attrs, i| Fabricate(:video, title: "video_name_#{i}") }
  title { "" }
end