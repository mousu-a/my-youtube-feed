# frozen_string_literal: true

class YoutubeSubscriptionsSyncer
  def call(_name, _started, _finished, _unique_id, payload)
    user = payload[:user]
    channel_attrs = payload[:channel_attrs]
    yt_ids = channel_attrs.pluck(:youtube_channel_id)

    YoutubeSubscription.insert_all(newly_subscriptions(user, channel_attrs, yt_ids), record_timestamps: true) # rubocop:disable Rails/SkipsModelValidations
    unsubscribed_records(user, yt_ids).delete_all
  end

  def newly_subscriptions(user, channel_attrs, yt_ids)
    new_subscribed_channel_yt_ids = new_subscribed_channels(user, channel_attrs, yt_ids).pluck(:youtube_channel_id)
    new_subscribe_channel_ids = Channel.where(youtube_channel_id: new_subscribed_channel_yt_ids).pluck(:id)
    new_subscribe_channel_ids.map do |channel_id|
      {
        channel_id:,
        user_id: user.id
      }
    end
  end

  def new_subscribed_channels(user, channel_attrs, yt_ids)
    ids = user.subscribed_channels.where(youtube_channel_id: yt_ids).pluck(:youtube_channel_id).to_set
    channel_attrs.reject { |channel| ids.include?(channel[:youtube_channel_id]) }
  end

  def unsubscribed_records(user, current_subscription_yt_ids)
    user.youtube_subscriptions.joins(:channel).where.not(channels: { youtube_channel_id: current_subscription_yt_ids })
  end
end
