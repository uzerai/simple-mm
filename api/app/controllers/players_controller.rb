# frozen_string_literal: true

class PlayersController < ApplicationController

  def index
    render json: Player.all.as_json(include: :matches)
  end

  def show
    render json: Player.find(params[:id]).as_json(include: :matches)
  end
end
