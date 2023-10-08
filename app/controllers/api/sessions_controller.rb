class Api::SessionsController < ApiController
  skip_before_action :authenticate_user!
  before_action :set_default_format

  def create
    user = User.find_by(email: user_params[:email])

    if user && user.valid_password?(user_params[:password])
      token = Api::JsonWebToken.encode(id: user.id)
      render json: { token: token }
    else
      render json: { errors: ["Invalid email or password"] }, status: :unauthorized
    end
  end

  def destroy
    render json: { message: "Session closed" }
  end 

  private

  def set_default_format
    request.format = :json unless params[:format]
  end

  def user_params
    params.require(:user).permit(:email, :password)
  end
end
