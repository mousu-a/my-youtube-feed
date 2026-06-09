# frozen_string_literal: true

module LoginSupport
  def sign_in_with_google(user, name: user.name, email: user.email)
    mock_google_oauth(user, name:, email:)
    visit root_path
    click_on 'Googleアカウントでログイン'

    expect(page).to have_text 'ログインしました'
  end

  private

  def mock_google_oauth(user, name:, email:)
    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:google_oauth2] =
      OmniAuth::AuthHash.new(
        provider: user.provider,
        uid: user.uid,
        info: {
          name:,
          email:,
          image: user.avatar_url
        }
      )
  end
end
