require_relative './initial_game.rb'

class Api::V1::GamesController < ApplicationController
  skip_before_action :authorized, only: [:create]
  before_action :find_game, only: [:edit, :update, :destroy]

  # def index
  #   @games = Game.all
  #   render json: @games
  # end

  # def create
  #   @game = Game.create(
  #                       player1_id: game_params[:player1_id],
  #                       player2_id: game_params[:player2_id],
  #                       turn: 0,
  #                       finished: false,
  #                       winner: 0)
  #   render json: @game
  # end

  # def update
  #   @game.update(game_params)
  #   if @game.save
  #     render json: @game, status: :accepted
  #   else
  #     render json: 
  #       { errors: @game.errors_full_messages },
  #       status: :unprocessible_entity
  #   end
  # end

  # def destroy
  #   if @game.destroy
  #     render json: { game_destroyed: true }, status: :accepted
  #   else
  #     render json: 
  #       { errors: @game.errors_full_messages },
  #       status: :unprocessible_entity
  #   end
  # end

  def active
    # byebug
    @active_games = Game
                      .all.to_a
                      .select {|game| !game.finished && !game.player2_id.nil?}
    
    unless @active_games.empty?
      render json: @active_games
    else
      render json: { status: 'no active games', ready: false }
    end
  end
  
  # def available
  #   # byebug
  #   @available_games = Game
  #                     .all.to_a
  #                     .select {|game| !game.finished && game.player2_id.nil?}
    
  #   unless @available_games.empty?
  #     render json: @available_games, each_serializer: GameSerializer
  #   else
  #     render json: { status: 'no available games', ready: false }
  #   end
  # end

  def create
    # byebug
    @game = Game.create(
      player1_id: game_params[:player_id],
      player2_id: game_params[:opponent_id],
      turn: 0,
      finished: false,
      winner: 0,
      game_state: INITIAL_GAME)
    render json: @game
  end

  def find_open_game
    @empty_game = Game
                    .all
                    .sort {|a, b| a.created_at <=> b.created_at }
                    .filter {|game| game.player2_id == nil }
                    .last
  end


  def turn?
    if @game.player2.nil?
      render json: { status: 'Waiting for Player 2', ready: false }
    else
      if @game.turn > game_params[:turn]
        render json: { status: 'New turn available', ready: true }
      else
        render json: { status: 'Waiting for Opponent', ready: false }
      end
    end
  end

  def import
    render json: @game
  end

  def export
    @game.update(game_params)
    if @game.save
      render json: @game, status: :accepted
    else
      render json: 
        { errors: @game.errors_full_messages },
        status: :unprocessible_entity
    end
  end

  def win
  end

  def exit
  end

  private

  def game_params
    params.require(:game).permit(:id, :player_id, :opponent_id, :finished, :winner, :turn, :game_state)
  end

  def find_game
    @game = Game.find(game_params[:id])
  end
end
