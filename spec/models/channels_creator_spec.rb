# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ChannelsCreator do
  describe '#call' do
    let(:channel_attrs) { attributes_for_list(:channel, 5) }
    let(:payload) { { channel_attrs: } }

    before do
      create(:channel, channel_attrs.first)
    end

    it 'creates only channels that do not already exist' do
      expect do
        described_class.new.call(nil, nil, nil, nil, payload)
      end.to change(Channel, :count).by(4)
    end
  end
end
