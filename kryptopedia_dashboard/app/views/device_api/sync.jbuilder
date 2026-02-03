json.synced_to @synced_to.iso8601

json.items @teams do |team|
  json.type "team"
  json.number team.team.number
  json.nickname team.team.nickname
  json.deleted !!team.deleted_at
end