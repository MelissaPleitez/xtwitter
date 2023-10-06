class Users::RegistrationsController < Devise::RegistrationsController
    skip_before_action :verify_authenticity_token, only: [:create] # Opcional: deshabilitar la verificación CSRF para crear

  def create
    build_resource(sign_up_params)

    if resource.save
      # Genera un token JWT después de un registro exitoso
    #   token = Api::JsonWebToken.encode(id: resource.id)
      
    #   render json: { token: token }
    sign_in(resource) # Inicia sesión automáticamente al usuario
    redirect_to  web_tweets_path
   
    else
      render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :username)
  end
end
