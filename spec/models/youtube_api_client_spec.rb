# frozen_string_literal: true

require 'rails_helper'

RSpec.describe YoutubeAPIClient do
  let(:access_token) { 'mock_access_token' }
  let(:youtube) { described_class.new(access_token) }

  describe '#subscriptions' do
    context 'when list_subscriptions returns no items' do
      before do
        allow(youtube).to receive(:list_subscriptions).and_return(
          double('ListSubscriptionsResponse', items: [])
        )
      end

      it 'returns an empty array' do
        expect(youtube.subscriptions).to eq([])
      end
    end

    context 'when list_subscriptions returns subscriptions' do
      let(:youtube_channel_id) { 'UCxxxxxxxxxxxxxxxxxxxxxx' }
      let(:channel_name) { 'Test Channel' }
      let(:icon_url) { 'https://example.com/thumbnail.jpg' }
      let(:response) do
        double(
          'Snippet',
          title: channel_name,
          resource_id: double('ResourceId', channel_id: youtube_channel_id),
          thumbnails: double(
            'Thumbnails',
            high: double(url: icon_url),
            medium: nil,
            default: nil
          )
        )
      end

      before do
        allow(youtube).to receive(:list_subscriptions).and_return(
          double('ListSubscriptionsResponse', items: [double('SubscriptionItem', snippet: response)])
        )
      end

      it 'returns subscriptions parsed to match the channels DB schema' do
        expect(youtube.subscriptions).to eq(
          [
            {
              youtube_channel_id:,
              name: channel_name,
              url: "https://www.youtube.com/channel/#{youtube_channel_id}",
              icon_url:,
              videos_playlist_id: youtube_channel_id.sub(/\AUC/, 'UU')
            }
          ]
        )
      end
    end
  end

  describe '#list_subscriptions' do
    let(:service) { double('YouTubeService') }

    before do
      allow(Google::Apis::YoutubeV3::YouTubeService)
        .to receive(:new)
        .and_return(service)

      allow(service).to receive(:authorization=)

      allow(service)
        .to receive(:list_subscriptions)
        .and_return(list_subscriptions_response)
    end

    context 'when there are no subscribed channels' do
      let(:list_subscriptions_response) do
        double('ListSubscriptionsResponse', items: [])
      end

      it 'returns no items' do
        expect(youtube.list_subscriptions.items).to eq([])
      end
    end

    context 'when subscriptions exist' do
      let(:response) do
        double(
          'Snippet',
          title: 'Test Channel',
          resource_id: double('ResourceId', channel_id: 'UCxxxxxxxxxxxxxxxxxxxxxx'),
          thumbnails: double(
            'Thumbnails',
            high: double(url: 'https://example.com/thumbnail.jpg'),
            medium: nil,
            default: nil
          )
        )
      end

      let(:list_subscriptions_response) do
        double('ListSubscriptionsResponse', items: [response])
      end

      it 'returns the user subscriptions' do
        expect(youtube.list_subscriptions.items).to eq([response])
      end
    end
  end
end
