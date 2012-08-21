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

  factory :talk do
    sequence(:title) { |n| "Talk #{n}" }
    description "Don't miss this fabulous talk about something of which I have yet to think!"
    speaker     "Joe Schmo"
    room        "Room 101"
    start_at    DateTime.civil(2012, 6, 27, 9, 0, 0)
    end_at      DateTime.civil(2012, 6, 27, 11, 30, 0)
    event
  end

  factory :post do
    sequence(:title) { |n| "Post #{n}" }
    content "This is my wonderful blog post.  It's so wonderful I can barely contain my (hitherto bounded) excitement."
    user
  end
end
