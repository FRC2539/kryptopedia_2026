class ScoutingDataItemsController < ApplicationController
  include ScoutedEventConcern
  before_action :restrict_to_team_admin

  def index
    @items = @scouted_event.scouting_data_items
  end

  def edit
    @item = @scouted_event.scouting_data_items.find_by(uid: params[:uid])
  end

  def update
    @item = @scouted_event.scouting_data_items.find_by(uid: params[:uid])
    data = params[:scouting_data_item][:data]
    parsed_data = JSON.parse(data) rescue nil
    if parsed_data && @item.update(data: parsed_data)
      redirect_to team_scouted_event_scouting_data_items_path(@scouted_event), notice: "Item updated!"
    else
      render :edit
    end
  end

  def destroy
    @item = @scouted_event.scouting_data_items.find_by(uid: params[:uid])
    @item.destroy
    redirect_to team_scouted_event_scouting_data_items_path(@scouted_event), notice: "Item deleted!"
  end

  def restore
    @item = @scouted_event.scouting_data_items.find_by(uid: params[:scouting_data_item_uid])
    if @item.deleted?
      @item.update(deleted_at: nil)
      redirect_to team_scouted_event_scouting_data_items_path(@scouted_event), notice: "Item restored!"
    else
      redirect_to team_scouted_event_scouting_data_items_path(@scouted_event), alert: "Item is not deleted."
    end
  end

  private

  def item_params
    params.require(:scouting_data_item).permit(:data)
  end
end
