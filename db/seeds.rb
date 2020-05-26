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


#Workouts
Workout.create!(name: "Rakis Beetroot Bootcamp",
             style: "Cardio",
             url: "https://www.youtube.com/embed/Y3hXYININJw",
             length: 60,
             intensity: "High",
             spacesays: "a carefully planned workout that will send you home crimson!",
             equipment: true
           )

Workout.create!(name: "DanZ GainZ",
             style: "Strength",
             url: "https://www.youtube.com/embed/pymKHcywkuc",
             length: 90,
             intensity: "High",
             spacesays: "alwayZ wnid a bodE like DanZ. Now U CanZ!",
             equipment: true)

Workout.create!(name: "Gigis Big Bum Row",
             style: "Cardio",
             url: "https://www.youtube.com/embed/pymKHcywkuc",
             length: 30,
             intensity: "Medium",
             spacesays: "alwayZ wnid a bootE like d G. Now U Can!",
             equipment: true)

10.times do |n|
  name  = Faker::Superhero.name
  style = Rails.application.config_for(:workoutinfo)["styles"]
            .shuffle.first
  #domainend = %w[.com .in .org].shuffle.first
  #url = "www.#{name.split.join + domainend}"
  domain = %w[https://www.youtube.com/embed/pymKHcywkuc https://www.youtube.com/embed/Y3hXYININJw]
  url = domain.shuffle.first
  length = [30,60,90].shuffle.first
  intensity = %w[High Medium Low].shuffle.first
  spacesays = ["d boss of all workouts", "we love this workout for its simplicity", "a complex workout that will take some time to master", "we really stared to see the benefit of this afte 3-4 sessions" "definitely incorporate this into your day several times a week"].shuffle.first
  equipment = [true, false].shuffle.first
  Workout.create!(name: name, style: style, url: url, length: length, intensity: intensity, spacesays: spacesays, equipment: equipment)
        end
