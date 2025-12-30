class PagesController < ApplicationController
  def index
    @teams = Team.all.select { |team| team.enrolled? }.sort_by(&:number)
  end
end
