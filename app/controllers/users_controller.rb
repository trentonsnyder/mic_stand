class UsersController < ApplicationController
  
  def index
    redirect_to new_user_registration_path
  end
  
  def password
    redirect_to new_user_password_path
  end
end
