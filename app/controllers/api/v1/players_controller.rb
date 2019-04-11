class Api::V1::PlayersController < ApplicationController
  before_action :find_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = Player.all
    render json: @players
  end

  def create
    @player = Player.create(
                        username: player_params[:username],
                        email: player_params[:email],
                        password: player_params[:password],
                        wins: 0,
                        losses: 0)
    render json: @player
  end

  def update
    @player.update(player_params)
    if @player.save
      render json: @player, status: :accepted
    else
      render json: 
        { errors: @player.errors_full_messages },
        status: :unprocessible_entity
    end
  end

  def destroy
    if @player.destroy
      render json: { player_destroyed: true }, status: :accepted
    else
      render json: 
        { errors: @player.errors_full_messages },
        status: :unprocessible_entity
    end
  end

  private

  def player_params
    params.require(:player).permit(:id, :username, :email, :password)
  end

  def find_player
    @player = Player.find(params[:id])
  end
end
