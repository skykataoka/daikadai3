require 'csv'
CSV.foreach('db/facebook.csv') do |row|
  Topic.create(user_id: row[0],
               title: row[1],
               content: row[2])
  sleep(1)
end

# User
20.times do
  email = Faker::Internet.email
  name = Faker::Name.name
  password = "password"
  num = format('%03d', [*001..141].sample)
  user = User.new(
          email: email,
          name: name,
          password: password,
          password_confirmation: password,
          snsid: SecureRandom.uuid,
        )
  user.skip_confirmation!
  user.save
end



# Commnet
60.times do
  user_id = [*1..20].sample
  topic_id = [*1..6].sample
  content = Yoshida::Text.sentence
  Comment.create!(
    user_id: user_id,
    topic_id: topic_id,
    content: content
  )
end
