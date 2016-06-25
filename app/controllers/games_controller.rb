class GamesController < ApplicationController
  skip_before_action :verify_authenticity_token  #disables CSRF token

  def index
  end

  def create
    render json: {id: new_game.id}, status: 200
  end

  def show
    game_hash = {
      score: game.score,
      frame_number: game.frames.count,
      game_over: game.game_over?,
    }
    render json: game_hash, status: 200
  end

  def update
    if params[:knocked_pins].nil?
      render json: {message: "The number of knocked pins is required."}, status: 500
      return
    end

    game.throw! knocked_pins: params[:knocked_pins].to_i
    render json: {}, status: 200
  rescue GameError => e
    render json: {message: e.message}, status: 500
  rescue AvailablePinsError => e
    render json: {message: e.message}, status: 500
  end

private

  def new_game
    @new_game ||= Game.create
  end

  def game
    @game ||= Game.find(params[:id].to_i)
  end
end
