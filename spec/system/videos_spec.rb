# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos' do
  let(:user) { create(:user) }
  let(:channel) { create(:channel, name: 'Test Channel', url: 'https://www.youtube.com/channel/UCtest') }

  before { sign_in_with_google(user) }

  context 'when user has no follows' do
    scenario 'shows follow prompt' do
      visit videos_path

      expect(page).to have_text('チャンネルをフォローしましょう')
      expect(page).to have_link('フォロー画面へ', href: follows_path)
    end
  end

  context 'when live videos exist' do
    before do
      create(:follow, user:, channel:)
      create(:video, :live, channel:, title: 'Live Now')
    end

    scenario 'shows live section' do
      visit videos_path

      expect(page).to have_css('section.live')
      expect(page).to have_text('ライブ配信中')
      expect(page).to have_text('Live Now')
    end
  end

  context 'when upcoming videos exist' do
    before do
      create(:follow, user:, channel:)
      create(:video, :upcoming, channel:, title: 'Upcoming Stream')
    end

    scenario 'shows upcoming section' do
      visit videos_path

      expect(page).to have_css('section.upcoming')
      expect(page).to have_text('配信予定')
      expect(page).to have_text('Upcoming Stream')
    end
  end

  context 'when only archive videos exist' do
    before do
      create(:follow, user:, channel:)
      create(:video, :archive, channel:, title: 'Archived Video')
    end

    scenario 'shows archives section' do
      visit videos_path

      expect(page).to have_css('section.archives')
      expect(page).to have_text('アーカイブ')
      expect(page).to have_text('Archived Video')
    end
  end

  context 'when filter terms exist' do
    before do
      create(:follow, user:, channel:)
      create(:channel_filter_term, user:, channel:, name: 'Ruby')
      create(:video, :live, channel:, title: 'Python Live')
      create(:video, :upcoming, channel:, title: 'Python Upcoming', live_start_time: 2.hours.from_now)
      create(:video, :archive, channel:, title: 'Ruby Tutorial')
      create(:video, :archive, channel:, title: 'Python Tutorial')
    end

    scenario 'filters archives but not live or upcoming' do
      visit videos_path

      expect(page).to have_text('Python Live')
      expect(page).to have_text('Python Upcoming')
      expect(page).to have_text('Ruby Tutorial')
      expect(page).to have_no_text('Python Tutorial')
    end
  end

  context 'when no videos exist' do
    before do
      create(:follow, user:, channel:)
    end

    scenario 'shows empty state' do
      visit videos_path

      expect(page).to have_text('動画がありません')
    end
  end

  context 'when channel link is displayed' do
    before do
      create(:follow, user:, channel:)
      create(:video, :archive, channel:, title: 'Channel Link Test')
    end

    scenario 'links channel icon and name to YouTube channel' do
      visit videos_path

      expect(page).to have_link('Test Channel', href: 'https://www.youtube.com/channel/UCtest')
    end
  end
end
