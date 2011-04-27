class User < ActiveRecord::Base
  has_many :busses

  accepts_nested_attributes_for :busses, :allow_destroy=>true, :reject_if=>:all_blank  
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :recoverable, :rememberable, :trackable, :validatable, :confirmable, :registerable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :name, :display_name, :phone_number, :busses_attributes
  
  # validates_presence_of :name, :if=>:confirmation_sent_at?
  # validates_presence_of :display_name, :if=>:confirmation_sent_at?
  # validates_phone_number :phone_number, :allow_nil=>true, :allow_blank=>true
  
  validates_presence_of :password_confirmation, :if=>:password_required?
  
  private
  def password_required?
    (confirmation_sent_at? && encrypted_password.blank?) || password.present? || password_confirmation.present?
  end
end
