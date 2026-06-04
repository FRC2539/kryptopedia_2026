json.nickname @team.nickname

json.events @events do |event|
  json.id event.hashid
  json.name event.name
  json.code event.code
  json.year event.season.year
  json.test event.test
end

json.devices @devices do |device|
  json.id device.hashid
  json.name device.name
  json.used device.session.present?
end
