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
		encode_token({
    	id: current_user.id, 
    	players: current_user.players
    		.as_json(only: [:id, :game_id]),
      valid: Time.zone.now.iso8601,
      expire: (Time.zone.now + (params[:remember_me] ? 1.years : ENV.fetch('JWT_TOKEN_EXPIRE_MINUTES'){ 720 }.to_i.minutes)).iso8601,
      permissions: []
  	})
  end

end
