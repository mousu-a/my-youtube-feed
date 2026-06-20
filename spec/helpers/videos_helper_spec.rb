# frozen_string_literal: true

require 'rails_helper'

RSpec.describe VideosHelper do
  describe '#video_time_label' do
    it 'returns elapsed time with 前 suffix' do
      video = build(:video, published_at: 2.hours.ago)

      expect(helper.video_time_label(video)).to include('前')
    end
  end

  describe '#youtube_video_url' do
    it 'returns YouTube watch URL' do
      video = build(:video, youtube_video_id: 'abc123')

      expect(helper.youtube_video_url(video)).to eq('https://www.youtube.com/watch?v=abc123')
    end
  end
end
