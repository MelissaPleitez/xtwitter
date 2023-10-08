class Api::UsersController < ApiController
    before_action :set_user, only: %i[show edit update destroy]
    before_action :set_default_format
    skip_before_action :authenticate_user!
    
    def index
      @users = User.all
      render 'index', formats: :json
    end
  
    def show
      @user = User.find(params[:id])
      render 'show', formats: :json
    end
  
    def new
      # This action is used with HTML
    end
  
    def create
      @user = User.new(user_params)
  
      respond_to do |format|
        if @user.save
          format.json { render :show, status: :created }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    def edit
      # This action is used with HTML
    end
  
    def update
      respond_to do |format|
        if @user.update(user_params)
          format.json { render :show, status: :ok }
        else
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  
    private
  
    def set_user
      @user = User.find(params[:id])
    end
  
    def user_params
      params.require(:user).permit(:email, :username, :password)
    end
  
    # JSON format by default
    def set_default_format
      request.format = :json unless params[:format]
    end
  end
  
