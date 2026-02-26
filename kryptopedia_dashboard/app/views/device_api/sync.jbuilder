json.synced_to @synced_to.iso8601
json.pit_map_data @event.pit_map if @should_update_pit_map

json.items do
  json.array! @teams do |team|
    json.type "team"
    json.deleted !!team.deleted_at
    json.number team.team.number
    json.nickname team.team.nickname
  end

  json.array! @matches do |match|
    json.type "match"
    json.deleted false
    json.number match.number
    json.comp_level match.comp_level
    json.red1number match.red1.number
    json.red2number match.red2.number
    json.red3number match.red3.number
    json.blue1number match.blue1.number
    json.blue2number match.blue2.number
    json.blue3number match.blue3.number
  end

  json.array! @team_members do |member|
    json.type "team_member"
    json.deleted false # deleting team members is not GP
    json.id member.hashid
    json.name member.name
  end

  json.array! @scouting_data_items do |item|
    json.type item.data_type
    json.deleted !!item.deleted_at
    if item.deleted?
      json.data do
        json.uid item.uid
      end
    else
      json.data JSON.parse(item.data)
    end
  end
end