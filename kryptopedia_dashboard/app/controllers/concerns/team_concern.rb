module TeamConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_team
  end

  def set_team
    @team = Team.find_by(number: params[:team_number]) if params[:team_number].present?
    unless @team&.enrolled?
      redirect_to root_path, alert: "who? that team doesn't use this."
    end
  end

  def current_user
    if session[:team_member_id]
      @current_user ||= TeamMember.find_by(id: session[:team_member_id], team: @team)
    end
  end

  def restrict_to_team_admin
    unless current_user&.admin? && current_user.team == @team
      redirect_to root_path, alert: "no access!! go away!"
    end
  end

end
