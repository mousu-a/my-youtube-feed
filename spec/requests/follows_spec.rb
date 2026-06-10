require 'rails_helper'

RSpec.describe 'Follows' do
  describe 'GET /index' do
    it 'returns http success' do
      get '/follows/index'
      expect(response).to have_http_status(:success)
    end
  end
end
