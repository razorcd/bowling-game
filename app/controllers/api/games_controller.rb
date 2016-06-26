class Api::GamesController < ApplicationController
  skip_before_action :verify_authenticity_token  #disables CSRF token

  def create
    render json: {id: new_game.id}, status: 201
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
    if game
      game.throw! knocked_pins: update_params[:knocked_pins].to_i
      render json: {}, status: 204
    else
      render json: {message: "Game not found."}, status: 404
    end

  rescue GameError, AvailablePinsError => e
    render json: {message: e.message}, status: 422
  end

private

  def new_game
    @new_game ||= Game.create
  end

  def game
    @game ||= Game.find_by(id: params[:id])
  end

  def update_params
    raise(ActionController::ParameterMissing, "Wrong knocked pins data format.") if params[:knocked_pins].to_s.chars.any? {|c| c=~/[^\d]/}
    params.require(:knocked_pins)
    params.permit(:knocked_pins)
  end
end
