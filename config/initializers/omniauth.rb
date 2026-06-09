# frozen_string_literal: true

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2,
           ENV.fetch('GOOGLE_CLIENT_ID', nil),
           ENV.fetch('GOOGLE_CLIENT_SECRET', nil),
           scope: 'email,profile',
           prompt: 'consent'
  on_failure { |env| OmniAuth::FailureEndpoint.new(env).redirect_to_failure }
end
