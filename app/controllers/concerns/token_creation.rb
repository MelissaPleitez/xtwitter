module TokenCreation extend ActiveSupport::Concern 

    def create_token(email, password)
        token = Api::AuthenticationController.new 
        new_token = token.create(email, password)
        new_token
    end
end