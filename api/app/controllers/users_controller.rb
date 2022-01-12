class UsersController < BaseController
  before_action :configure_permitted_parameters, if: :devise_controller?
	before_action :authorized, only: [:auto_login]

  def create
    unless params[:password] == params[:password_confirm]
      add_error(409, "Password does not match password confirm.")
      render_response(409)
    end

    @user = User.new(username: params[:username], email: params[:email], password: params[:password_confirm])
    
    if @user.save!
      @results = { token: current_user_token }
      render_response
    else
      add_error(403, "Invalid username or password.")
      render_response(403)
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.valid_password?(params[:password])
      @results = { token: current_user_token }
      render_response
    else
      add_error(403, "Invalid username or password.")
      render_response(403)
    end
  end

  def auto_login
    @results = { token: current_user_token }
    render_response
  end

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
