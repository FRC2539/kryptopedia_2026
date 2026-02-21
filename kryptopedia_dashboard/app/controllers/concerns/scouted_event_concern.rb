module ScoutedEventConcern
  extend ActiveSupport::Concern

  included do
    include TeamConcern
    before_action :set_scouted_event
    layout "scouted_events"
  end

  def set_scouted_event
    @scouted_event = @team.scouted_events.find_by_hashid!(params[:scouted_event_id]) if params[:scouted_event_id].present?
  end

end