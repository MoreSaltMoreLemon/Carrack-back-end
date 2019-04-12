class Api::V1::GamesController < ApplicationController
  before_action :find_game, only: [:edit, :update, :destroy]

  def index
    @games = Game.all
    render json: @games
  end

  def create
    @game = Game.create(
                        player1: game_params[:player1_id],
                        player2: game_params[:player2_id],
                        turn: 0,
                        finished: false,
                        winner: 0)
    render json: @game
  end

  def update
    @game.update(game_params)
    if @game.save
      render json: @game, status: :accepted
    else
      render json: 
        { errors: @game.errors_full_messages },
        status: :unprocessible_entity
    end
  end

  def destroy
    if @game.destroy
      render json: { game_destroyed: true }, status: :accepted
    else
      render json: 
        { errors: @game.errors_full_messages },
        status: :unprocessible_entity
    end
  end

  def available_players
  end

  def join_game
  end

  private

  def game_params
    params.require(:game).permit(:id)
  end

  def find_game
    @game = Game.find(params[:id])
  end
end
