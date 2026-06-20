# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Video do
  describe '.display_videos' do
    let(:user) { create(:user) }
    let(:followed_channel) { create(:channel, name: 'Followed Channel') }
    let(:unfollowed_channel) { create(:channel, name: 'Unfollowed Channel') }

    before do
      create(:follow, user:, channel: followed_channel)
    end

    it 'returns only videos from followed channels' do
      followed_video = create(:video, :archive, channel: followed_channel, title: 'Followed Video')
      create(:video, :archive, channel: unfollowed_channel, title: 'Unfollowed Video')

      result = described_class.display_videos(user)

      expect(result[:archives]).to contain_exactly(followed_video)
      expect(result[:live_streams]).to be_empty
      expect(result[:upcoming_streams]).to be_empty
    end

    context 'when live videos exist' do
      let!(:older_live) do
        create(:video, :live, channel: followed_channel, title: 'Older Live', published_at: 2.hours.ago)
      end
      let!(:newer_live) do
        create(:video, :live, channel: followed_channel, title: 'Newer Live', published_at: 1.hour.ago)
      end

      it 'returns live videos sorted newest first' do
        expect(described_class.display_videos(user)[:live_streams]).to eq([newer_live, older_live])
      end
    end

    context 'when upcoming videos exist' do
      let!(:later_upcoming) do
        create(
          :video, :upcoming,
          channel: followed_channel,
          title: 'Later Upcoming',
          live_start_time: 3.hours.from_now,
          published_at: 1.day.ago
        )
      end
      let!(:sooner_upcoming) do
        create(
          :video, :upcoming,
          channel: followed_channel,
          title: 'Sooner Upcoming',
          live_start_time: 1.hour.from_now,
          published_at: 1.day.ago
        )
      end

      it 'returns upcoming videos sorted by soonest live_start_time first' do
        expect(described_class.display_videos(user)[:upcoming_streams]).to eq([sooner_upcoming, later_upcoming])
      end
    end

    context 'when archive videos exist without filter terms' do
      let!(:first_archive) do
        create(:video, :archive, channel: followed_channel, title: 'First Archive', published_at: 2.days.ago)
      end
      let!(:second_archive) do
        create(:video, :archive, channel: followed_channel, title: 'Second Archive', published_at: 1.day.ago)
      end

      it 'returns all archive videos' do
        expect(described_class.display_videos(user)[:archives]).to eq([second_archive, first_archive])
      end
    end

    it 'filters archive videos by channel filter terms case-insensitively' do
      create(:channel_filter_term, user:, channel: followed_channel, name: 'Ruby')
      matched_video = create(
        :video, :archive,
        channel: followed_channel,
        title: 'Ruby on Rails入門',
        published_at: 1.day.ago
      )
      create(:video, :archive, channel: followed_channel, title: 'Python入門', published_at: 2.days.ago)

      expect(described_class.display_videos(user)[:archives]).to contain_exactly(matched_video)
    end

    context 'when filter terms exist' do
      before do
        create(:channel_filter_term, user:, channel: followed_channel, name: 'Ruby')
        create(:video, :archive, channel: followed_channel, title: 'Python Archive', published_at: 1.day.ago)
      end

      let!(:live_video) do
        create(:video, :live, channel: followed_channel, title: 'Python Live', published_at: 1.hour.ago)
      end
      let!(:upcoming_video) do
        create(
          :video, :upcoming,
          channel: followed_channel,
          title: 'Python Upcoming',
          live_start_time: 2.hours.from_now,
          published_at: 1.day.ago
        )
      end

      it 'does not filter live and upcoming videos' do
        result = described_class.display_videos(user)

        expect(result[:live_streams]).to contain_exactly(live_video)
        expect(result[:upcoming_streams]).to contain_exactly(upcoming_video)
        expect(result[:archives]).to be_empty
      end
    end
  end
end
