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

  scope :live, -> { where(live_broadcast_status: 'live') }
  scope :upcoming, -> { where(live_broadcast_status: 'upcoming') }
  scope :archives, -> { where(live_broadcast_status: 'none') }

  def self.display_videos(user)
    videos = where(channel: user.followed_channels).includes(:channel)
    terms_by_channel = user.channel_filter_terms.group_by(&:channel_id)

    {
      live_streams: live_streams(videos),
      upcoming_streams: upcoming_streams(videos),
      archives: filtering_archives(videos, terms_by_channel)
    }
  end

  def self.live_streams(videos)
    videos.live.order(published_at: :desc)
  end

  def self.upcoming_streams(videos)
    videos.upcoming.order(Arel.sql('live_start_time ASC NULLS LAST, published_at ASC'))
  end

  def self.filtering_archives(videos, terms_by_channel)
    archive_videos = videos.archives.select do |video|
      terms = terms_by_channel[video.channel_id]

      terms.blank? || terms.any? { |term| video.title.downcase.include?(term.name.downcase) }
    end

    archive_videos.sort_by(&:published_at).reverse
  end

  private_class_method :live_streams, :upcoming_streams, :filtering_archives
end
