class ApiController < ApplicationController 
  skip_before_action :verify_authenticity_token
  # attr_reader :current_user
  before_action :set_default_format
  # before_action :authenticate_token!
  before_action :authenticate_user!

  
  private 

  def set_default_format
    request.format = :json
  end


end