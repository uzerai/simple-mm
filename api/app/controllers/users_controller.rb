class UsersController < BaseController
	before_action :authorized, only: [:auto_login]

  def create
    @user = User.create(user_params)

    if @user.valid?
      @response = { token: current_user_token }
      render_response
    else
      add_error(403, "Invalid username or password.")
      render_response(403)
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
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

  private

  def user_params
    params.permit(:email, :password, :remember_me)
  end

  def current_user_token
		current_user.jwt_token(params[:remember_me])
  end

end
