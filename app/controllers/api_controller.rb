class ApiController < ApplicationController 
  attr_reader :current_user
  before_action :set_default_format
  before_action :authenticate_token!

  private 

  def set_default_format
    request.format = :json
  end

  def authenticate_token!
    # Rails.logger.debug "Error"
    puts auth_token
      payload = Api::JsonWebToken.decode(auth_token)
      @current_user = User.find(payload["sub"])
  rescue JWT::ExpiredSignature 
      render json: {errors: ["Auth token has Expired"]}, status: :unauthorized
  rescue JWT::DecodeError
    render json: {errors: ["Invalid auth token"]}, status: :unauthorized
  end

  def auth_token 
    @auth_token ||= request.headers.fetch("Authorization", "").split(" ").last
  end
end