class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  def current_user
    if cookies.signed[:session_auth_token].present?
      cookies.signed[:session_auth_token] = { value: cookies.signed[:session_auth_token], expires: 1.week.from_now }

      @session ||= Session.find_by(auth_token: cookies.signed[:session_auth_token])
      @current_user ||= @session&.owner
    elsif request.headers["Authorization"].present?
      auth_token = request.headers["Authorization"].split(" ").last

      @session ||= Session.find_by(auth_token: auth_token)
      @current_user ||= @session&.owner
    end

    @current_user
  end
end
