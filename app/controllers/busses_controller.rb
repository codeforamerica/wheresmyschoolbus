class BussesController < ApplicationController
  #TODO: before_filter :auth_user_or_admin
  layout nil
  before_filter :authenticate_user!
  
  def index
    if params[:fleet_id]
      if bus = Bus.find_by_fleet_id(params[:fleet_id])
        @busses = fetch_bus_locations([bus])
      else
        @busses = []
      end
      render :json => @busses.to_json
    else
      @busses = fetch_bus_locations(current_user.busses)
    end
  end
  
  def show
  end
  
  private
  def fetch_bus_locations(busses)
    busses.map do |b|
      location = $zonar.bus(b.fleet_id)
      next unless location.keys.include? 'currentlocations'
      bus_geojson_from(location)
    end.compact
  end
  
  def bus_geojson_from(location)
    {
      :type => "Feature",
      :geometry => {
        :type => "Point",
        :coordinates => [
          location['currentlocations']['asset'].delete('long'),
          location['currentlocations']['asset'].delete('lat')
        ]
      },
      :properties => location['currentlocations']['asset']
    }
  end
  
  def auth_user_or_admin
    #TODO: write
  end
end
