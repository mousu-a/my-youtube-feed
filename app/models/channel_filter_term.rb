# frozen_string_literal: true

class ChannelFilterTerm < ApplicationRecord
  belongs_to :user
  belongs_to :channel

  validates :user_id, uniqueness: { scope: %i[channel_id name] }
  validates :name, presence: true
end
