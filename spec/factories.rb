FactoryGirl.define do
  factory :user do
    sequence(:name)  { |n| "Test User #{n}" }
    sequence(:email) { |n| "testuser#{n}@eventicator.com" }
    password "foobar"
    password_confirmation "foobar"

    factory :admin do
      admin true
    end
  end

  factory :event do
    sequence(:name) { |n| "Test Event #{n}" }
    description "A once-in-a-lifetime, can't-miss event.  All the cool people will be there."
    location    "Duke Energy Convention Center\n525 Elm Street\nCincinnati, OH 45202"
    start_date  Date.civil(2012, 6, 27)
    end_date    Date.civil(2012, 6, 29)
  end
end

