# frozen_string_literal: true

class User < ApplicationRecord
  has_many :follows, dependent: :destroy
  has_many :followed_channels, through: :follows, source: :channel
  has_many :youtube_subscriptions, dependent: :destroy
  has_many :subscribed_channels, through: :youtube_subscriptions, source: :channel
  has_many :channel_filter_terms, dependent: :destroy

  validates :uid, uniqueness: { scope: :provider }
  validates :avatar_url,
            :email,
            :name,
            :provider,
            :uid,
            presence: true
end
