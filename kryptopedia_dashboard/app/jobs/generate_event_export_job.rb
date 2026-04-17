class GenerateEventExportJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    event = ScoutedEvent.find(args[0])
    exclude_comments = args[1] || false
    requested_by = TeamMember.find(args[2])

    sheet = RODF::Spreadsheet.new

    sheet.table "teams" do |t|
      t.row do |r|
        r.cell "Number"
        r.cell "Nickname"
      end
      event.teams.each do |team|
        t.row do |r|
          r.cell team.number
          r.cell team.nickname
        end
      end
    end

    sheet.table "matches" do |t|
      t.row do |r|
        r.cell "Comp Level"
        r.cell "Match Number"
        r.cell "Red 1"
        r.cell "Red 2"
        r.cell "Red 3"
        r.cell "Blue 1"
        r.cell "Blue 2"
        r.cell "Blue 3"
      end
      event.matches.each do |m|
        t.row do |r|
          r.cell m.comp_level
          r.cell m.number
          r.cell m.red1&.number
          r.cell m.red2&.number
          r.cell m.red3&.number
          r.cell m.blue1&.number
          r.cell m.blue2&.number
          r.cell m.blue3&.number
        end
      end
    end

    scouting_data = event.scouting_data_items
    scouting_data_types = scouting_data.map(&:data_type).uniq

    scouting_data_types.each do |data_type|
      items = scouting_data.select { |d| d.data_type == data_type }
      columns = items.map(&:data).flat_map(&:keys).uniq
      columns.reject! { |col| col.include?("comment") } if exclude_comments

      sheet.table data_type.humanize.pluralize do |t|
        t.row do |r|
          r.cell "uid"
          r.cell "Scouter hashid"
          r.cell "deleted at"
          r.cell "created at"
          r.cell "updated at"
          columns.each { |col| r.cell col.humanize }
        end
        items.each do |item|
          t.row do |r|
            r.cell item.uid
            r.cell item.team_member.hashid
            r.cell item.deleted_at
            r.cell item.created_at
            r.cell item.updated_at
            columns.each { |col| r.cell item.data[col] }
          end
        end
      end
    end

    export = ScoutedEventExport.new(scouted_event: event, team_member: requested_by, excludes_comments: exclude_comments)
    export.file.attach(io: StringIO.new(sheet.bytes), filename: "#{event.code}_#{"no_comments_" if exclude_comments}#{Time.now.to_i}.ods", content_type: "application/vnd.oasis.opendocument.spreadsheet")

    export.save!
  end
end
