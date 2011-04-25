# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
Wheresmybus::Application.initialize!

ActiveSupport::Inflector.inflections do |inflection| 
  inflection.irregular "bus", "busses"
end