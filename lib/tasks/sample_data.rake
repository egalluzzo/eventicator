namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    admin = User.create!(name: "Administrator",
                         email: "admin@eventicator.com",
                         password: "foobar",
                         password_confirmation: "foobar")
    admin.toggle!(:admin)
    99.times do |n|
      name  = Faker::Name.name
      email = "user#{n+1}@eventicator.com"
      password  = "password"
      User.create!(name: name,
                   email: email,
                   password: password,
                   password_confirmation: password)
    end

    5.times do |n|
      Event.create!(name: Faker::Lorem.words(3).collect { |w| w.capitalize }.join(' '),
                    description: Faker::Lorem.paragraphs(2).join("\n\n"),
                    location: "#{Faker::Address.street_address}\n#{Faker::Address.city}, #{Faker::Address.state_abbr} #{Faker::Address.zip}",
                    start_date: Date.civil(2013, n + 1, 1),
                    end_date: Date.civil(2013, n + 1, 2))
    end
  end
end
