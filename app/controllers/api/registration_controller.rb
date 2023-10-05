class Api::RegistrationController < ApiController
    skip_before_action :authenticate_user!
    before_action :user_params, only: %i[ show edit update destroy ]
    before_action :set_default_format
  

    def create
        user = User.new(user_params)
    
        if user.save
          token = Api::JsonWebToken.encode(id: user.id)
          render json: { token: token }
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end
    
      private
    
      def user_params
        params.require(:user).permit(:name, :username, :email, :password)
      end
    
      def set_default_format
        request.format = :json unless params[:format]
    end

end
