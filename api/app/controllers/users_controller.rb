class UsersController < ApplicationController
	before_action :authorized, only: [:auto_login]

  def create
    @user = User.create(user_params)

    if @user.valid?
      render json: { results: { token: current_user_token }, errors: nil }
    else
      render json: { 
        results: nil, 
        errors: [ 
          { 
            code: :unauthenticated, 
            message: "Invalid username or password." 
          } 
        ] 
      }, status: :unauthenticated
    end
  end

  def login
    @user = User.find_by(email: params[:email])

    if @user && @user.authenticate(params[:password])
      render json: { 
        results: { token: current_user_token },
        errors: nil,
      }	
    else
      render json: { 
        results: nil,
        errors: [
          { 
            code: :unauthenticated,
            message: "Invalid username or password."
          }
        ]
      }, status: :unauthenticated
    end
  end

  def auto_login
    render json: { 
      results: { token: current_user_token },
      errors: nil
    }
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
