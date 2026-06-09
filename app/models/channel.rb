# frozen_string_literal: true

class Channel < ApplicationRecord
  has_many :videos, dependent: :destroy
  has_many :youtube_subscriptions, dependent: :destroy
  has_many :follows, dependent: :destroy
  has_many :channel_filter_terms, dependent: :destroy

  validates :youtube_channel_id, presence: true, uniqueness: true
  validates :name,
            :url,
            :icon_url,
            :videos_playlist_id,
            presence: true
end
