# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Videos' do
  let(:user) { create(:user) }

  describe 'GET /videos' do
    context 'when logged out' do
      it 'redirects to root path' do
        get videos_path

        expect(response).to redirect_to(root_path)
      end
    end

    context 'when logged in' do
      before { sign_in(user) }

      it 'returns success' do
        get videos_path

        expect(response).to have_http_status(:ok)
      end

      it 'shows follow prompt when user has no follows' do
        get videos_path

        expect(response.body).to include('チャンネルをフォローしましょう')
        expect(response.body).to include(follows_path)
      end

      it 'shows live section when live videos exist' do
        channel = create(:channel)
        create(:follow, user:, channel:)
        create(:video, :live, channel:, title: 'Live Stream Title')

        get videos_path

        expect(response.body).to include('Live Stream Title')
      end
    end
  end
end
