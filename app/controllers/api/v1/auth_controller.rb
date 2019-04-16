class Api::V1::AuthController < ApplicationController
  skip_before_action :authorized, only: [:create]

  def new
  end

  def create
    # POST /api/v1/login
    @player = Player.find_by(username: player_login_params[:username])
    if @player && @player.authenticate(player_login_params[:password])
      @token = encode_token({ player_id: @player.id })
      @player.activity = 'active'
      @player.save
      render json: { player: PlayerSerializer.new(@player), jwt: @token }, status: :accepted
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end

  def destroy
    @player = Player.find_by(username: player_login_params[:username])
    if @player && @player.authenticate(player_login_params[:password])
      @player.activity = 'inactive'
    else
      render json: { message: 'An error occurred during logout' }, status: :unauthorized
    end
  end

  private

  def player_login_params
    params.require(:player).permit(:username, :password, :email)
  end
end