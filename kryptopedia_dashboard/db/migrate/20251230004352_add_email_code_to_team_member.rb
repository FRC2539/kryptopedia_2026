class AddEmailCodeToTeamMember < ActiveRecord::Migration[8.1]
  def change
    add_column :team_members, :email_code, :integer
    add_column :team_members, :email_code_sent_at, :datetime
  end
end
