# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

#Video.create(title: '', description: '', small_cover_url: '', big_cover_url: '')
#Video.create(title: '', description: '', small_cover_url: '', big_cover_url: '')
#Video.create(title: '', description: '', small_cover_url: '', big_cover_url: '')

Video.delete_all
Category.delete_all

ActiveRecord::Base.connection.reset_pk_sequence!("videos")
ActiveRecord::Base.connection.reset_pk_sequence!("categories")

Category.create(title: "TV Commedies")
Category.create(title: "TV Dramas")
Category.create(title: "Reality TV")

18.times do
  title = ['futurama', 'south_park', 'family_guy'].sample
  #binding.pry
  Video.create( title: title, 
                description: 'This is a good movie.', 
                small_cover_url: "/tmp/#{title}.jpg",
                big_cover_url: '/tmp/monk_large.jpg',
                category_id: Random.new.rand(1..Category.all.size) )
end   


