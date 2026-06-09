# frozen_string_literal: true

class Video < ApplicationRecord
  belongs_to :channel

  validates :youtube_video_id, presence: true, uniqueness: true
  validates :data_refreshed_at,
            :description,
            :live_broadcast_status,
            :published_at,
            :thumbnail_url,
            :title,
            presence: true
end
