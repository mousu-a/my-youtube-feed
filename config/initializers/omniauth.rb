# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
    ENV.fetch('GOOGLE_CLIENT_ID'),
    ENV.fetch('GOOGLE_CLIENT_SECRET'),
    scope: 'email,profile'
    # TODO 開発が終わったら戻す
    #  prompt: 'consent'
  provider :google_oauth2, ENV.fetch('GOOGLE_YOUTUBE_CLIENT_ID'), ENV.fetch('GOOGLE_YOUTUBE_CLIENT_SECRET'), {
    name: 'google_youtube',
    scope: 'email,profile,youtube.readonly',
    # prompt: 'consent',
    include_granted_scopes: 'true'
  }
  on_failure { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
end
