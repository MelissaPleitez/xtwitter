class Web::UsersController < ApplicationController


    def show
        @user = User.find_by(username: params[:username])
        @tweets = @user.tweets 
        @followers_count = @user.followers.count
        @following_count = @user.followees.count
    end

    def edit
        # Renderiza la vista de edición del perfil
      end
    
      def update
        if @user.update(user_params)
          redirect_to web_user_path(@user.username), notice: "Perfil actualizado exitosamente."
        else
          render :edit
        end
    end

    def follow
        @user_to_follow = User.find(params[:id])
        @follow = Follow.new(follower: current_user, followee: @user_to_follow)
    
        respond_to do |format|
          if @follow.save
            format.html { redirect_to web_user_path(@user_to_follow.username), notice: "Started following the user!" }
          else
            format.html { redirect_to web_user_path(@user_to_follow.username), alert: "Unable to follow the user." }
          end
        end
      end

      def unfollow
        @user_to_unfollow = User.find(params[:id])
        @follow = Follow.find_by(follower: current_user, followee: @user_to_unfollow)
    
        respond_to do |format|
          if @follow&.destroy
            format.html { redirect_to web_user_path(@user_to_unfollow.username), notice: "Stopped following the user." }
          else
            format.html { redirect_to web_user_path(@user_to_unfollow.username), alert: "Unable to unfollow the user." }
          end
        end
      end

    private

  
    def user_params
      params.require(:user).permit(:name, :username, :email) 
    end
end