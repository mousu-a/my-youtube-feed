# frozen_string_literal: true

Rails.application.config.after_initialize do
  # Channel → YoutubeSubscription この順番は必ず守る
  ActiveSupport::Notifications.subscribe('youtube_subscriptions.sync', ChannelsCreator.new)
  ActiveSupport::Notifications.subscribe('youtube_subscriptions.sync', YoutubeSubscriptionsSyncer.new)
end
