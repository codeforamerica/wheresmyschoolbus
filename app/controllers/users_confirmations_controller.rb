#this code taken from https://github.com/plataformatec/devise/wiki/How-To:-Override-confirmations-so-users-can-pick-their-own-passwords-as-part-of-confirmation-activation

class UsersConfirmationsController < Devise::ConfirmationsController
  skip_before_filter(:authenticate_user!)
  # PUT /resource/confirmation
  def update
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token,params[:confirmation_token])

    if @confirmable.new_record?
      #if the token doesn't exist, they're already confirmed, or they never existed. what's the best way to deal?
      flash[:notice]="invalid confirmation token"
      redirect_to :action=>:new 
      return false;
    end
      
    if @confirmable.confirmed?
      #this should be impossible, really.
      raise "you already confirmed, yo"
      return false
    end
     
    @confirmable.update_attributes(params[:user]) #update all their attributes, including password & profile info
    if @confirmable.valid?
      do_confirm
    else
      do_show
    end

  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    @confirmable = User.find_or_initialize_with_error_by(:confirmation_token,params[:confirmation_token])

    if @confirmable.new_record?
      #if the token doesn't exist, they're already confirmed, or they never existed. what's the best way to deal?
      flash[:notice]="invalid confirmation token"
      redirect_to :action=>:new 
      return false;
    end
    
    if @confirmable.confirmed?
      #this should be impossible, really.
      raise "you already confirmed, yo"
      return false
    end
    
    #CANNOT confirm off of a show. must put back with a form
    do_show
  end
  
  protected

  def do_show
    @confirmation_token = params[:confirmation_token]
    @requires_password = true
    self.resource = @confirmable
    render_with_scope :show
  end

  def do_confirm
    @confirmable.confirm!
    set_flash_message :notice, :confirmed
    sign_in_and_redirect(resource_name, @confirmable)
  end
end
