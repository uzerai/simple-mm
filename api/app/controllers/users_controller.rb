class UsersController < ApplicationController
	before_action :authorized, only: [:auto_login]

  def create
    @user = User.create(user_params)

    if @user.valid?
      @response = { token: current_user_token }
      render_response
    else
      add_error(:unauthenticated, "Invalid username or password.")
      render_response(:unauthenticated)
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      @results = { token: current_user_token }
      render_response
    else
      add_error(:unauthenticated, "Invalid username or password.")
      render_response(:unauthenticated)
    end
  end

  def auto_login
    @results = { token: current_user_token }
    render_response
  end

  private

  def user_params
    params.permit(:email, :password)
  end

  def current_user_token
		encode_token({
    	user_id: @user.id, 
    	players: @user.players
    		.as_json(only: [:id, :game_id])
  	})
  end

end
