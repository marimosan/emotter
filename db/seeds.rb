# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

gravatar_id = Digest::MD5::hexdigest("user@example.com")
gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}"

User.create!(nickname: "Example User", image_url: gravatar_url)

99.times do |n|
  name = Faker::Name.name
  User.create!(nickname: name, image_url: gravatar_url)
end

users = User.order(:created_at).take(1)
50.times do
  users.each { |user| user.emos.create!(content: "喜んでる")}
end
