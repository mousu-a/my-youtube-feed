# frozen_string_literal: true

FactoryBot.define do
  factory :channel_filter_term do
    user
    channel
    name { 'Ruby' }
  end
end
