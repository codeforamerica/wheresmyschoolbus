class BussesController < ApplicationController
  #TODO: before_filter :auth_user_or_admin
  layout nil
  before_filter :auth_user_or_admin!
  
  def index
    if user_signed_in?
      @busses = fetch_bus_locations(current_user.busses)
    else #admin
      @busses = [] #$zonar.fleet["assetlist"]["assets"].map {|b| {:properties=>{'fleet'=>b['fleet']}} }#fetch_all_bus_locations
    end
  end
  
  def show
    if user_signed_in?
      if bus = current_user.busses.find_by_fleet_id(params[:id])
        @bus = fetch_bus_locations([bus]).first
      end
    else #admin can view all
      @bus = fetch_bus_locations([Bus.new(:fleet_id=>params[:id])]).first
    end
    render :partial => 'details' if params[:details]
  end
  
  def path
    respond_to do |format|
      format.json  { render :json => fetch_bus_path(params[:id]) }
    end
  end
  
  private
  def fetch_bus_locations(busses)
    busses.map do |b|
      location = $zonar.bus(b.fleet_id)
      next unless location.keys.include? 'currentlocations'
      time = location['currentlocations']['asset']['time'].gsub("EDT", "")
      location['currentlocations']['asset']['time'] = Chronic.parse(time).to_s
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
    end.compact
  end
  
  def fetch_bus_path(bus)
    path = $zonar.path(bus)
    if path['pathevents']['assets']
      coordinates = $zonar.path(bus)['pathevents']['assets'][0]['events'].map do |location|
        [ location['lng'], location['lat'] ]
      end
      return {
        :type => "LineString",
        :coordinates => coordinates
      }
    else
      return {}
    end
  end

  def auth_user_or_admin!
    authenticate_user! unless user_signed_in? or admin_signed_in?
  end
end