FactoryBot.define do
  factory :user do
    name { 'MyString' }
    email { 'MyString' }
    provider { 'MyString' }
    uid { 'MyString' }
    avatar_url { 'MyString' }
    admin { false }
  end
end
