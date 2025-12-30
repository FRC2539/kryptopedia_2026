class TeamsController < ApplicationController
  include TeamConcern

  before_action :dont_reauth!, only: [:login, :send_login_code, :verify_login_code, :process_login_code]

  def login
  end

  rate_limit to: 10, within: 3.minutes, only: [:send_login_code, :process_login_code]

  def send_login_code
    @team_member = @team.team_members.find_by(email: params[:email].strip.downcase) if @team
    if @team_member
      @team_member.send_email_code!
      redirect_to team_verify_login_code_path(@team)
    else
      redirect_to team_login_path(@team), alert: "who?"
    end
  end

  def verify_login_code
  end

  def process_login_code
    @team_member = @team.team_members.find_by email_code: params[:code], email_code_sent_at: 10.minutes.ago..Time.now
    if @team_member
      @team_member.update!(email_code: nil, email_code_sent_at: nil)
      session[:team_member_id] = @team_member.id
      redirect_to team_events_path(@team)
    else
      redirect_to team_verify_login_code_path(@team), alert: "nope. maybe it expired?"
    end
  end

  def logout
    session[:team_member_id] = nil
    redirect_to team_login_path(@team), notice: "logged out!"
  end

  private

  def dont_reauth!
    if current_user
      redirect_to team_events_path(@team)
    end
  end
end
