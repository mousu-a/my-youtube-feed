# frozen_string_literal: true

class SessionsController < ApplicationController
  def create
    auth = request.env['omniauth.auth']
    user = OmniAuthUserResolver.find_or_create_user(auth)
    if user.persisted?
      login(user)
      redirect_to videos_path, notice: t('.login_success')
    else
      redirect_to root_path, alert: t('.login_failure')
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: t('.logout_success'), status: :see_other
  end

  def auth_failure
    reset_session
    redirect_to root_path, alert: t('.auth_failure'), status: :see_other
  end

  private

  def login(user)
    reset_session
    session[:user_id] = user.id
  end
end
