FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@example.com" }
    provider { 'google_oauth2' }
    sequence(:uid) { |n| "uid#{n}" }
    avatar_url { 'https://example.com/avatar.jpg' }
    admin { false }
  end
end
