FactoryBot.define do
  factory :channel do
    sequence(:youtube_channel_id) { |n| "UC#{n}" }
    name { 'MyString' }
    url { 'https://www.youtube.com/channel/UCexample' }
    icon_url { 'https://example.com/icon.jpg' }
    videos_playlist_id { 'MyString' }
    videos_refreshed_at { '2026-06-08 19:56:32' }
  end
end
