class Users::SessionsController < Devise::SessionsController

  
    def create
        super do |resource|
            if resource.persisted?
              token = Api::JsonWebToken.encode(id: resource.id)
              render json: { token: token }
              sign_up(resource)
            end
        end
    end
  
 
end
