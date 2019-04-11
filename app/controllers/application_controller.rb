require 'jwt'

class ApplicationController < ActionController::API
  before_action :authorized

  def encode_token(payload) #{ player_id: 2 }
    byebug
    JWT.encode(payload, 'my_s3cr3t') #issue a token, store payload in token
  end

  def auth_header
    request.headers['Authorization'] # Bearer <token>
  end

  def decoded_token
    if auth_header()
      token = auth_header.split(' ')[1] #[Bearer, <token>]
      begin
        JWT.decode(token, 'my_s3cr3t', true, algorithm: 'HS256')
        # JWT.decode => [{ "player_id"=>"2" }, { "alg"=>"HS256" }]
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_player
    if decoded_token()
      player_id = decoded_token[0]['player_id'] #[{ "player_id"=>"2" }, { "alg"=>"HS256" }]
      @player = player.find_by(id: player_id)
    else
      nil
    end
  end

  def logged_in?
    !!current_player
  end

  def authorized
    render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
  end
end
