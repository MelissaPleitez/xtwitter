class Api::RegistrationController < ApiController
skip_before_action :authenticate_token!

    def index 
        user = User.new
    end

    def create 
        user = User.find_by(email: params[:user][:email])
        if user && user.valid_password?(params[:user][:password])
            render json: {token: Api::JsonWebToken.encode(sub: user.id)}
        else
            render json: { errors: ["Invalid email or password"]}  
        end 
    end



end
