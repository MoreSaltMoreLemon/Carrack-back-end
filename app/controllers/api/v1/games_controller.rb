require_relative './initial_game.rb'

class Api::V1::GamesController < ApplicationController
  skip_before_action :authorized, only: [:create]
  before_action :find_game, only: [:turn?, :import, :export, :win, :exit]

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

  def create
    # byebug
    @game = Game.create(
      player1_id: game_params[:player_id],
      player2_id: game_params[:opponent_id],
      turn: 0,
      finished: false,
      winner: 0,
      game_state: INITIAL_GAME)
    @game.player1.activity = 'playing'
    @game.player2.activity = 'playing'
    render json: @game
  end

  def join
    # byebug
    @joined_game = Game
                    .all
                    .last
        # .select {|game| game.player1_id == @player.id && !game.finished }
    render json: @joined_game
  end


  def turn?
    if @game.turn > game_params[:turn]
      if @game.finished && @game.winner > 0 
        render json: { status: 'You lost!', ready: true }
      elsif @game.finished
        render json: { status: 'Opponent has quit', ready: true }
      else
        render json: { status: 'New turn available', ready: true }
      end
    else
      render json: { status: 'Waiting for Opponent', ready: false }
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
    @game.update(game_params)
    @game.finished = true
    @game.winner = @player.id
    @game.save
    render json: { status: 'You won!', ready: true }
  end

  def exit
    @game.update(game_params)
    @game.finished = true
    @game.save
    render json: { status: 'Quitter', ready: true }
  end

  private

  def game_params
    params.require(:game).permit(:id, :player_id, :opponent_id, :finished, :winner, :turn, :game_state)

  end

  def find_game
    @game = Game.find(game_params[:id])
  end
end
