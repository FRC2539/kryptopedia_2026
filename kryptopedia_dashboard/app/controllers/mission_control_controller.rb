class MissionControlController < ApplicationController
  before_action :restrict_to_2539_admin

  private

  def restrict_to_2539_admin
    unless current_user&.admin? && current_user.team.number == 2539
      render json: { error: "no" }, status: :forbidden
    end
  end

end
