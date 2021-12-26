# frozen_string_literal: true

class PlayersController < ApplicationController
  def index
    @results = Player.all.as_json(include: :matches)
    render_response
  end

  def show
    @results = Player.find(params[:id]).as_json(include: :matches)

    unless @results.present?
      add_error(:not_found, "Player not found.")
    end
    
    render_response
  end
end
