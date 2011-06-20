class Bus < ActiveRecord::Base
  belongs_to :user
  
  def nickname
    self['nickname'].blank? ? self.fleet_id : "#{self['nickname']} - #{self.fleet_id}"
  end
end
