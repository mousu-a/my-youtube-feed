# frozen_string_literal: true

class YoutubeSubscription < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  validates :user_id, uniqueness: { scope: :channel_id }
end
