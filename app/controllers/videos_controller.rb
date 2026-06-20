# frozen_string_literal: true

class VideosController < ApplicationController
  before_action :require_login

  def index
    @follows = current_user.follows
    display = Video.display_videos(current_user)
    @live_streams = display[:live_streams]
    @upcoming_streams = display[:upcoming_streams]
    @archives = display[:archives]
  end
end
