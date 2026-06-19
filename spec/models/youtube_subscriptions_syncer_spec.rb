# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YoutubeSubscriptionsSyncer do
  describe '#call' do
    let(:payload) { { user:, channel_attrs: } }
    let(:call_syncer) { described_class.new.call(nil, nil, nil, nil, payload) }

    context 'when new subscriptions exist on YouTube' do
      let(:youtube_subscribed_channels) { create_list(:channel, 5) }
      let(:user) { create(:user) }
      let(:channel_attrs) { youtube_subscribed_channels.map { |channel| channel.attributes.symbolize_keys } }

      before do
        create(:youtube_subscription, user:, channel: youtube_subscribed_channels.first)
      end

      it 'creates missing subscriptions' do
        expect do
          call_syncer
        end.to change(YoutubeSubscription, :count).by(4)
      end
    end

    context 'when subscriptions have been removed from YouTube' do
      let!(:youtube_subscribed_channels) { create_list(:channel, 5) }
      let(:user) { create(:user) }
      let(:channel_attrs) { youtube_subscribed_channels.first(4).map { |channel| channel.attributes.symbolize_keys } }

      before do
        youtube_subscribed_channels.map do |channel|
          create(:youtube_subscription, user:, channel:)
        end
      end

      it 'deletes obsolete subscriptions' do
        expect do
          call_syncer
        end.to change(YoutubeSubscription, :count).by(-1)
      end
    end
  end
end
