# frozen_string_literal: true

class FollowsController < ApplicationController
  FOLLOW_LIMIT = 15

  def index
    @subscriptions = current_user.youtube_subscriptions.includes(:channel)
    @follows = current_user.follows.includes(:channel)
    @followed_channel_ids = @follows.map(&:channel_id)
    @remaining_follow_count = FOLLOW_LIMIT - @follows.size
    @follow_limit = FOLLOW_LIMIT
  end

  def create
    return redirect_to follows_path, alert: t('.follow_limit_reached') if current_user.follows.count >= FOLLOW_LIMIT

    channel = Channel.find(channel_params)
    current_user.follows.create(channel:)
    redirect_to follows_path
  end

  def destroy
    current_user.follows.destroy(params[:id])
    redirect_to follows_path
  end

  private

  def channel_params
    params.expect(:channel_id)
  end
end
