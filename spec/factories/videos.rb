# frozen_string_literal: true

FactoryBot.define do
  factory :video do
    channel
    sequence(:youtube_video_id) { |n| "video_#{n}" }
    title { 'Sample Video' }
    description { 'Sample description' }
    thumbnail_url { 'https://example.com/thumbnail.jpg' }
    live_broadcast_status { 'none' }
    published_at { Time.zone.parse('2026-06-08 19:57:00') }
    live_start_time { nil }
    live_end_time { nil }
    data_refreshed_at { Time.zone.parse('2026-06-08 19:57:00') }

    trait :live do
      live_broadcast_status { 'live' }
      live_start_time { 1.hour.ago }
    end

    trait :upcoming do
      live_broadcast_status { 'upcoming' }
      live_start_time { 1.hour.from_now }
    end

    trait :archive do
      live_broadcast_status { 'none' }
      live_start_time { nil }
      live_end_time { nil }
    end
  end
end
