# frozen_string_literal: true

class ChannelsCreator
  def call(_name, _started, _finished, _unique_id, payload)
    channel_attrs = payload[:channel_attrs]

    Channel.insert_all(new_channel_records(channel_attrs), record_timestamps: true) # rubocop:disable Rails/SkipsModelValidations
  end

  def new_channel_records(channels)
    new_channels = pick_new_channels(channels)
    new_channels.select { |attr| Channel.new(attr).valid? }
  end

  def pick_new_channels(channels)
    channel_youtube_ids = channels.pluck(:youtube_channel_id)
    exists_youtube_ids = Channel.where(youtube_channel_id: channel_youtube_ids).pluck(:youtube_channel_id).to_set
    channels.reject { |channels| exists_youtube_ids.include?(channels[:youtube_channel_id]) }
  end
end
