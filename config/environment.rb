# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Wheresmybus::Application.initialize!

# for parsing zonar dates
Time.zone = "EST"
Chronic.time_class = Time.zone

# load the zonar API wrapper
require 'zonar'
$zonar = Zonar::Client.new ENV['ZONAR_SUBDOMAIN'], ENV['ZONAR_USERNAME'], ENV['ZONAR_PASSWORD']

ActiveSupport::Inflector.inflections do |inflection| 
  inflection.irregular "bus", "busses"
end

