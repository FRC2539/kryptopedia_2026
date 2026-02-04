json.synced_to @synced_to.iso8601

json.items do
  json.array! @teams do |team|
    json.type "team"
    json.deleted !!team.deleted_at
    json.number team.team.number
    json.nickname team.team.nickname
  end

  json.array! @team_members do |member|
    json.type "team_member"
    json.deleted false # deleting team members is not GP
    json.id member.hashid
    json.name member.name
  end
end