class Api::AuthenticationController < ApiController
    skip_before_action :authenticate_user!
    #  skip_before_action :authenticate_token!


    def create(email, password)
        if (@user = User.find_by(email:email)) && @user.valid_password?(password)
          token = Api::JsonWebToken.encode(id: @user.id)
          token
        end

    end
end
