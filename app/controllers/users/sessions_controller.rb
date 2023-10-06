class Users::SessionsController < Devise::RegistrationsController

  
    def create
        super do |resource|
            if resource.persisted?
              token = Api::JsonWebToken.encode(id: resource.id)
              render json: { token: token }
            end
        end
    end
  
 
end
