class ScoutingDataDuplicatesService

  UNIQUENESS_FIELDS = {
    "scouted_pit" => %w[team_number],
    "scouted_match" => %w[match_comp_level match_number team_number]
  }.freeze

  def initialize(scouted_event)
    @scouted_event = scouted_event
  end

  def self.uniqueness_keys_for(item)
    fields = UNIQUENESS_FIELDS[item.data_type]
    return nil unless fields

    item.data.slice(*fields)
  end

  def all_duplicates
    UNIQUENESS_FIELDS.flat_map do |data_type, _fields|
      duplicates_for_type(data_type)
    end
  end

  private

  def duplicates_for_type(data_type)
    all_items = @scouted_event.scouting_data_items.alive.where(data_type: data_type)
    fields = UNIQUENESS_FIELDS[data_type]

    group_expression = fields.map { |f| Arel.sql("data->>'#{f}'") }

    duplicates = all_items.group(group_expression).having("count(*) > 1").pluck(*group_expression).to_a

    duplicates.map do |values|
      scope = all_items
      fields.zip(values).each do |field, value|
        scope = scope.where("data->>'#{field}' = ?", value)
      end
      scope.to_a
    end
  end

end
