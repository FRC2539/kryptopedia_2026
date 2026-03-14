class SessionRequestsController < ApplicationController
  include TeamConcern
  before_action :restrict_to_team_admin

  def approve
    session_request = SessionRequest.alive.find_by_hashid!(params[:id])

    if session_request.device.session
      session_request.device.session.destroy!
    end

    session_request.update!(session: Session.create(owner: session_request.device, scouted_event: session_request.scouted_event))
    redirect_to team_home_feed_path(@team), notice: "Session approved."
  end

  def destroy
    session_request = SessionRequest.alive.find_by_hashid!(params[:id])
    session_request.destroy!
    redirect_to team_home_feed_path(@team), notice: "Session request denied."
  end
end
