class RegistrationsController < Devise::RegistrationsController
  prepend_before_filter :authenticate_scope!
  def edit_password
  end
end