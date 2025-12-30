class TeamMemberMailer < ApplicationMailer
  def verification_code_email(team_member)
    @team_member = team_member
    mail(to: @team_member.email, subject: "Your verification code is #{@team_member.email_code}")
  end
end
