class UsersController < BaseController
  before_action :configure_permitted_parameters, if: :devise_controller? # For devise config override
	before_action :authorized, only: [:auto_login]

  def create
   @user = User.new(username: params[:username], email: params[:email], password: params[:password], password_confirmation: params[:password_confirm])
    
    if @user.save
      @results = { token: current_user_token }
      render_response
    else
      add_model_errors @user
      render_response 422
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.valid_password?(params[:password])
      @results = { token: current_user_token }
      render_response
    else
      add_error 403, "Invalid username or password."
      render_response 403
    end
  end

  def auto_login
    @results = { token: current_user_token }
    render_response
  end

  # Custom devise configuration for permitted parameters 
  # during certain methods on this controller.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:create) do |user_params|
      user_params.permit(:email, :password, :password_confirm, :remember_me, :username)
    end
    
    devise_parameter_sanitizer.permit(:login) do |user_params|
      user_params.permit(:email, :password, :remember_me)
    end
  end

  private

  def current_user_token
		current_user.jwt_token(params[:remember_me])
  end
end
