require 'net/http'
require 'crack'

module Zonar
  class Client
    def initialize(subdomain, username, password)
      @username, @password = username, password
      @api = "#{subdomain}.zonarsystems.net"
    end

	  # gets all fleet_ids in the fleet.
    def fleet
      params = {:username => @username, :password => @password, :action => 'showopen', :operation => 'showassets', :format => 'json'}
      fetch(params)
    end

  	# gets current location of single bus
    def bus(fleet_id)
      params = {:username => @username, :password => @password, :action => 'showposition', :type => "Standard", :logvers => "3", :operation => 'current', :format => 'xml', :reqtype => "fleet", :target => fleet_id.gsub(' ', '%20')}
      fetch(params, 'xml')
    end
    
    # gets past locations for a single bus
    def path(fleet_id, since=900)
      now = Time.now.to_i
      past = now - since # default 900 = 15 minutes ago
      params = {:username => @username, :password => @password, :action => 'showposition', :type => "Standard", :version => "2", :logvers => "3", :operation => 'path', :format => 'json', :reqtype => "fleet", :target => fleet_id.gsub(' ', '%20'), :starttime => past, :endtime => now}
      fetch(params)
    end
    
    def fetch(params, format='json')
      data = get(params)
      if format == 'xml'
        return Crack::XML.parse(data.body)
      else
        return Crack::JSON.parse(data.body)
      end
    end
    
    def get(uri)
      request(Net::HTTP::Get.new("/interface.php?#{uri.to_query}"))
    end

    def request(req)
      res = Net::HTTP.start(@api, "80") { |http| http.request(req) }
      unless res.kind_of?(Net::HTTPSuccess)
        handle_error(req, res)
      end
      res
    end

    private

    def handle_error(req, res)
      e = RuntimeError.new("#{res.code}:#{res.message}\nMETHOD:#{req.method}\nURI:#{req.path}\n#{res.body}")
      raise e
    end
  end
end
