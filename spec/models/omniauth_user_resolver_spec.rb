# frozen_string_literal: true

require 'rails_helper'

RSpec.describe OmniAuthUserResolver do
  describe '.find_or_create_user' do
    context 'when the user already exists' do
      let!(:user) { create(:user) }
      let(:auth_hash) { auth_hash_for(uid: user.uid, provider: user.provider, email: user.email) }

      it 'does not create a new user' do
        expect { described_class.find_or_create_user(auth_hash) }.not_to change(User, :count)
      end

      it 'returns the existing user' do
        expect(described_class.find_or_create_user(auth_hash)).to eq user
      end
    end

    context 'when the user does not exist' do
      let(:auth_hash) do
        auth_hash_for(
          uid: 'New1234',
          provider: 'google_oauth2',
          email: 'new@example.com',
          name: 'New User',
          image: 'https://example.com/new_user.jpg'
        )
      end

      it 'creates a new user' do
        expect { described_class.find_or_create_user(auth_hash) }.to change(User, :count).by(1)
      end

      it 'persists profile attributes' do
        user = described_class.find_or_create_user(auth_hash)

        expect(user).to have_attributes(
          provider: 'google_oauth2',
          uid: 'New1234',
          email: 'new@example.com',
          name: 'New User',
          avatar_url: 'https://example.com/new_user.jpg'
        )
      end
    end

    context 'when name is blank' do
      let(:auth_hash) do
        auth_hash_for(
          uid: 'NoName1234',
          provider: 'google_oauth2',
          email: 'noname@example.com',
          name: ''
        )
      end

      it 'uses the guest name' do
        user = described_class.find_or_create_user(auth_hash)

        expect(user.name).to eq I18n.t('users.guest')
      end
    end
  end

  def auth_hash_for(uid:, provider:, email: 'test@example.com', name: 'test_user', image: 'https://example.com/test_user.jpg')
    OmniAuth::AuthHash.new(
      info: {
        name: name,
        email: email,
        image: image
      },
      uid: uid,
      provider: provider
    )
  end
end
