FactoryGirl.define do
  factory :user do
    name                  "Eric Galluzzo"
    email                 "egalluzzo@example.com"
    password              "foobar"
    password_confirmation "foobar"
  end
end
