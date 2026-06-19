# frozen_string_literal: true

class VideosController < ApplicationController
  def index
    @videos = Video.all
  end
end
