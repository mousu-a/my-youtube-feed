# frozen_string_literal: true

class YoutubeAPIClient
  def initialize(access_token)
    @youtube = Google::Apis::YoutubeV3::YouTubeService.new
    @youtube.authorization = access_token
  end

  # TODO: 50件以上ある場合のページネーションに対応する
  def subscriptions
    list_subscriptions.items.map do |item|
      snippet = item.snippet
      youtube_channel_id = snippet.resource_id.channel_id

      {
        youtube_channel_id: youtube_channel_id,
        name: snippet.title,
        url: "https://www.youtube.com/channel/#{youtube_channel_id}",
        icon_url: pick_thumbnail_url(snippet.thumbnails),
        # youtube_channel_idの一部を変換することでvideos_playlist_idに転用できる
        videos_playlist_id: youtube_channel_id.sub(/\AUC/, 'UU')
      }
    end
  end

  def list_subscriptions
    @youtube.list_subscriptions(
      'snippet',
      max_results: 50,
      mine: true
    )
  end

  def pick_thumbnail_url(thumbnails)
    thumbnails&.high&.url ||
      thumbnails&.medium&.url ||
      thumbnails&.default&.url
  end
end
