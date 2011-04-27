require 'httparty'

module Zonar
  class Client
    def initialize(subdomain, username, password)
      @username, @password = username, password
      @api = "http://#{subdomain}.zonarsystems.net/interface.php"
      @user_agent = "User-Agent: curl/7.19.7 (universal-apple-darwin10.0) libcurl/7.19.7 OpenSSL/0.9.8l zlib/1.2.3"
    end

	#gets all fleet_ids in the fleet.
    def fleet
      params = {:username => @username, :password => @password, :action => 'showopen', :operation => 'showassets', :format => 'json'}
      fetch(params)
    end

	#gets Data of single bus
    def bus(fleet_id)
      params = {:username => @username, :password => @password, :action => 'showposition', :type => "Standard", :logvers => "3", :operation => 'current', :format => 'xml', :reqtype => "fleet", :target => fleet_id.gsub(' ', '%20')}
      fetch(params)
    end
    
    def fetch(params)
      HTTParty.get(@api, {:query => params, :headers => {"User-Agent" => @user_agent}}).parsed_response
    end
  end
end
