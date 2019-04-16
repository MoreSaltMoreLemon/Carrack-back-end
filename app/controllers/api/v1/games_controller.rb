class Api::V1::GamesController < ApplicationController
  skip_before_action :authorized, only: [:create]
  before_action :find_game, only: [:edit, :update, :destroy]

  def index
    @games = Game.all
    render json: @games
  end

  def create
    @game = Game.create(
                        player1_id: game_params[:player1_id],
                        player2_id: game_params[:player2_id],
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

  def active
    byebug
    @active_games = Game
                      .all
                      .filter {|game| !game.finished && !game.player2_id.nil?}
    
    unless @active_games.empty?
      render json: @active_games
    else
      render json: { status: 'no available games', ready: false }
    end

  end

  def join
    @open_game = find_open_game
    if @open_game.nil?
      @game = Game.create(
        player1_id: game_params[:player_id],
        player2_id: nil,
        turn: 0,
        finished: false,
        winner: 0)
      render json: @game
    else 
      @open_game.player2_id = game_params[:player_id]
      @open_game.save

      render json: @open_game
    end
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
      render json: { status: 'waiting for player 2', ready: false }
    else
      if @game.turn > game_params[:turn]
        render json: { status: 'new turn available', ready: true }
      else
        render json: { status: 'waiting for other player', ready: false }
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
    params.require(:game).permit(:id, :player_id, :turn, :game_state)
  end

  def find_game
    @game = Game.find(game_params[:player_id])
  end
end
