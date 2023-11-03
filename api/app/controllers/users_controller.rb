# frozen_string_literal: true

class UsersController < BaseController
  before_action :configure_permitted_parameters, if: :devise_controller? # For devise config override

  skip_before_action :ensure_authorized, only: %i[create login]

  def create
    @user = User.new(username: params[:username], email: params[:email], password: params[:password],
                     password_confirmation: params[:password_confirm])

    if @user.save
      @token = @user.jwt_token(extended_expiry: params[:remember_me])
      @refresh_token = @user.refresh_token
      render_response 201
    else
      add_model_errors @user
      render_response 422
    end
  end

  def login
    @current_user = User.find_by(email: params[:email])

    if @current_user&.valid_password?(params[:password])
      @token = @current_user.jwt_token(extended_expiry: params[:remember_me])
      @refresh_token = @current_user.refresh_token

      render_response
    else
      add_error 403, 'Invalid username or password'
      render_response 403
    end
  end

  # Called on the base front-end when the users' token
  # will expire in less than 15 minutes.
  def auto_login
    @token = current_user.jwt_token(extended_expiry: false)
    @refresh_token = current_user.refresh_token
    render_response
  end

  protected

  # Custom devise configuratio overrides for permitted parameters
  # during certain methods on this controller.
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:create) do |user_params|
      user_params.permit(:email, :password, :password_confirm, :remember_me, :username)
    end

    devise_parameter_sanitizer.permit(:login) do |user_params|
      user_params.permit(:email, :password, :remember_me)
    end
  end
end
