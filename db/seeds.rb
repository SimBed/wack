# Users
User.create!(name:  "Dan SimBed",
             email: "dansimbed@gmail.com",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     true,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Amala Paw",
            email: "amala@wack.com",
            password:              "foobar",
            password_confirmation: "foobar",
            admin:     false,
            activated: true,
            activated_at: Time.zone.now)

User.create!(name:  "Gigi B",
             email: "Gigi@wack.org",
             password:              "foobar",
             password_confirmation: "foobar",
             admin:     false,
             activated: true,
             activated_at: Time.zone.now)

User.create!(name:  "Wacky Raki",
            email: "Raki@wack.org",
            password:              "foobar",
            password_confirmation: "foobar",
            admin:     false,
            activated: true,
            activated_at: Time.zone.now)

10.times do |n|
 name  = Faker::Name.name
 email = "example-#{n+1}@thespacejuhu.in"
 password = "password"
 User.create!(name:  name,
              email: email,
              password:              password,
              password_confirmation: password,
              activated: true,
              activated_at: Time.zone.now)

end

#Workouts
Workout.create!(name: "Rakis Beetroot Bootcamp",
             style: "Cardio",
             url: "https://www.youtube.com/embed/Y3hXYININJw",
             length: 60,
             intensity: "High",
             spacesays: "a carefully planned workout that will send you home crimson!",
             equipment: true,
             addedby: "SimBed",
             brand: "TEST - MUSIC ONLY",
             eqpitems: "beetroot carrot saag",
             bodyfocus: "Full Body",
             created_at: Date.new(2020,5,25))

Workout.create!(name: "DanZ GainZ",
             style: "Strength",
             url: "https://www.youtube.com/embed/viQx4KDivPY",
             length: 90,
             intensity: "High",
             spacesays: "alwayZ wnid a bodE like DanZ. Now U CanZ!",
             equipment: true,
             addedby: "SimBed",
             brand: "TEST - MUSIC ONLY",
             eqpitems: "socks, water",
             bodyfocus: "Full Body",
             created_at: Date.new(2020,5,26))

Workout.create!(name: "Gigis Big Bum Row",
             style: "Cardio",
             url: "https://www.youtube.com/embed/pymKHcywkuc",
             length: 30,
             intensity: "Medium",
             spacesays: "alwayZ wnid a bootE like d G. Now U Can!",
             equipment: true,
             addedby: "SimBed",
             brand: "TEST - MUSIC ONLY",
             eqpitems: "kitten only",
             bodyfocus: "Full Body",
             created_at: Date.new(2020,5,27))

Workout.create!(name: "Strength & Conditioning",
            style: "Strength",
            url: "https://www.youtube.com/embed/vI1Yf-MBczI",
            length: 32,
            intensity: "Medium",
            spacesays: "basic lower body exercises, easy to follow",
            equipment: false,
            addedby: "Wacky Raki",
            brand: "SELF",
            bodyfocus: "Lower",
            created_at: Date.new(2020,5,28))

Workout.create!(name: "HIIT Cardio",
             style: "Cardio",
             url: "https://www.youtube.com/embed/ml6cT4AZdqI",
             length: 28,
             intensity: "Medium",
             spacesays: "lower body, easy to follow, set your own pace",
             equipment: false,
             addedby: "Wacky Raki",
             brand: "SELF",
             bodyfocus: "Lower",
             created_at: Date.new(2020,5,28))

 Workout.create!(name: "Full Body Workout",
              style: "Full Body",
              url: "https://www.youtube.com/embed/IMctZ4i2FRw",
              length: 30,
              intensity: "Low",
              spacesays: "lower body, easy to follow, set your own pace",
              equipment: false,
              addedby: "Wacky Raki",
              brand: "Mady Morrison",
              bodyfocus: "Full Body",
              created_at: Date.new(2020,6,1))

Workout.create!(name: "HIIT Abs Focus Workout",
             style: "HIIT",
             url: "https://www.youtube.com/embed/oFlLNY4Fzm0",
             length: 35,
             intensity: "Medium",
             spacesays: "Killer abs workout. We loved it.",
             equipment: false,
             addedby: "Wacky Raki",
             brand: "SELF",
             bodyfocus: "Core",
             created_at: Date.new(2020,6,4))
=begin
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
  spacesays = ["d boss of all workouts", "we love this workout for its simplicity", "a complex workout that will take some time to master", "we really stared to see the benefit of this afte 3-4 sessions" \
  "definitely incorporate this into your day several times a week", "The BodyWeight Warrior is a legend. Recommend all his vids", "Starts off slowly, but gathers pace" ].shuffle.first
  equipment = [true, false].shuffle.first
  Workout.create!(name: name, style: style, url: url, length: length, intensity: intensity, spacesays: spacesays, equipment: equipment, created_at: 10.minutes.ago)
        end
=end
#Posts
exampleposts = ["Absolutely brill!", "I loved this one", "Disappointing workout. Seemed like instructor was doing this for the first time", \
  "Still recovering...", "Instructor's hair too long", "This is wrong", "Very distracted by shapeliness of instructors buttock", "How can workout do such bosom is there only", \
  "bahut sundar workout hai", "perhaps more focus on technique and less on the infuencermania", "an instructive follow-on by a highly experienced instructor", "meh", "is mainly for beginner only", "too easy for an Olympian like me", \
  "Her:Don't forget to breath.  Me:I'm not forgetting, I just can't.", "after 7 minutes the screen turned black. 10 minutes later im sitting with god", "Luckily my life insurance is already activated.", \
  "Is it normal to see angels while doing this exercise?", "I am doing this for past 15 days. Initially I was not able to complete 15 minutes but now I can complete 25 minutes. I will hit 28 mins soon", \
  "me and mine pati get sweaty doing the same", "make sure to have yours protein after this workouts", "my coffee spilt itself while I doing", "soon i will get up from chair and try this for real", \
  "i think is a good on but i haven't tried, as i have a knee pain and my doctor is says for to rest some more weeks"]
users = User.order(:created_at).take(10)
5.times do
  #content = Faker::Lorem.sentence(5)
  users.each { |user| user.microposts.create!(content: exampleposts.shuffle.first, workout_id: (1..7).to_a.shuffle.first.to_i) }
end

# Favourite Workouts
User.all.each do |user|
  faves = Workout.take(Workout.count).shuffle[0..4]
  faves.each { |fave| user.wkfollow(fave)}
  end
