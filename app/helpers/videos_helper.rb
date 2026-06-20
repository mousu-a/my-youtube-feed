# frozen_string_literal: true

module VideosHelper
  def video_time_label(video)
    "#{time_ago_in_words(video.published_at)}前"
  end

  def youtube_video_url(video)
    "https://www.youtube.com/watch?v=#{video.youtube_video_id}"
  end
end
