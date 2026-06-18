# frozen_string_literal: true

class YoutubeSubscriptionsController < ApplicationController
  before_action :require_login

  def create
    auth = request.env['omniauth.auth']
    youtube = YoutubeAPIClient.new(auth.credentials.token)
    ActiveSupport::Notifications.instrument('youtube_subscriptions.sync', user: current_user,
                                                                          channel_attrs: youtube.subscriptions)
    redirect_to follows_path
  rescue Google::Apis::Error => e
    Rails.logger.warn("YouTube sync failed: #{e.class} #{e.message}")
    redirect_to follows_path, alert: t('.sync_failed')
  end
end
