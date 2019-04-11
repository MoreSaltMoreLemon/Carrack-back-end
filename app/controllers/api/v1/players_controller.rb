class Api::V1::PlayersController < ApplicationController
  skip_before_action :authorized, only: [:create]
  before_action :find_player, only: [:show, :edit, :update, :destroy]

  def index
    @players = Player.all
    render json: @players
  end

  def create
    @player = Player.create(player_params)
    if @player.valid?
      render json: { player: PlayerSerializer.new(@player) }, status: :created
    else
      render json: { error: 'failed to create player' }, status: :not_acceptable
    end
  end

  def update
    byebug
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
    # username: player_params[:username],
    #                     email: player_params[:email],
    #                     password: player_params[:password],
    #                     wins: 0,
    #                     losses: 0
    params.require(:player).permit(:id, :username, :email, :password)
  end

  def find_player
    @player = Player.find(params[:id])
  end
end
