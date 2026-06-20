# frozen_string_literal: true

module RequestAuthSupport
  def sign_in(user)
    # request spec では session 直接操作が難しいため current_user をスタブ
    # rubocop:disable RSpec/AnyInstance
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    # rubocop:enable RSpec/AnyInstance
  end
end

RSpec.configure do |config|
  config.include RequestAuthSupport, type: :request
end
