class Api::SessionsController < ApiController
    skip_before_action :authenticate_user!
    before_action :set_default_format


    def create
        user = User.find_by(email: params[:user][:email])
        
        if user && user.valid_password?(params[:user][:password])
          token = Api::JsonWebToken.encode(id: user.id)
          render json: { token: token }
        else
          render json: { errors: ["Invalid email or password"] }, status: :unauthorized
        end
      end

    def destroy
   
    end 

      private

      def set_default_format
        request.format = :json unless params[:format]
    end
end
