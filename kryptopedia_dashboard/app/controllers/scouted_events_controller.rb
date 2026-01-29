class ScoutedEventsController < ApplicationController
  layout "teams"
  include TeamConcern
  before_action :restrict_to_team_admin

  def index

  end
end
