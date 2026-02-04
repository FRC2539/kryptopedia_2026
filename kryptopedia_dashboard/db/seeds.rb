# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

team = Team.find_or_create_by!(number: 2539)

["Blue 1", "Blue 2", "Blue 3", "Red 1", "Red 2", "Red 3"].each do |device_name|
  Device.find_or_create_by!(name: device_name, owner: team)
end

event = ScoutedEvent.find_or_create_by!(name: 'Test Event', code: "TEST2026", test: true, owner: team)

event.teams << Team.find_or_create_by!(number: 2539)
event.teams << Team.find_or_create_by!(number: 1678)
event.teams << Team.find_or_create_by!(number: 118)
event.teams << Team.find_or_create_by!(number: 176)

TeamMember.find_or_create_by!(team: team, email: "dominic@userexe.me", name: "Dominic", role: :admin)
