FactoryBot.define do
    factory :user do
      sequence(:email) { |n| "user#{n}@example.com" }
      password { "password" }
      isAdmin { false }
      approved { false }
      account_value { 100000 }
    end
  
    factory :admin_user, class: User do
      sequence(:email) { |n| "admin#{n}@example.com" }
      password { "password" }
      isAdmin { true }
      approved { true }
    end
  end
  