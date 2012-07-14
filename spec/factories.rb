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
end
