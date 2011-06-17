class Bus < ActiveRecord::Base
  belongs_to :user
  
  def nickname
    self['nickname'].blank? ? self.fleet_id : self['nickname']
  end
end
