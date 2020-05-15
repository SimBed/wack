# Users
User.create!(name:  "Dan SimBed",
             email: "dansimbed@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Kunal",
             email: "example@railstutorial.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)


#Problems
Workout.create!(name: "Rakis Beetroot Bootcamp",
             style: "Cardio",
             url: "https://www.youtube.com/watch?v=OEsW3S_NAuc",
             length: 60,
             intensity: "High")

Workout.create!(name: "DanZ GainZ",
             style: "Strength",
             url: "www.danzgainz.org",
             length: 90,
             intensity: "High")

Workout.create!(name: "Gigis Big Bum Row",
             style: "Cardio",
             url: "http://www.workthatbum.in",
             length: 30,
             intensity: "Medium")

10.times do |n|
  name  = Faker::Superhero.name
  style = Rails.application.config_for(:workoutinfo)["styles"]
            .shuffle.first
  domainend = %w[.com .in .org].shuffle.first
  url = "www.#{name.split.join + domainend}"
  length = [30,60,90].shuffle.first
  intensity = %w[High Medium Low].shuffle.first
  Workout.create!(name: name, style: style, url: url, length: length, intensity: intensity)
        end
