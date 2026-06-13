# frozen_string_literal: true

class YoutubeSubscriptionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    youtube = YoutubeAPIClient.new(auth.credentials.token)
    ActiveSupport::Notifications.instrument('youtube_subscriptions.sync', user: current_user,
                                                                          channel_attrs: youtube.subscriptions)
    redirect_to follows_path
  end
end
