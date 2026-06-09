FactoryBot.define do
  factory :video do
    channel { nil }
    youtube_video_id { 'MyString' }
    title { 'MyString' }
    description { 'MyText' }
    thumbnail_url { 'MyString' }
    live_broadcast_status { 'MyString' }
    published_at { '2026-06-08 19:57:00' }
    live_start_time { '2026-06-08 19:57:00' }
    live_end_time { '2026-06-08 19:57:00' }
    data_refreshed_at { '2026-06-08 19:57:00' }
  end
end
