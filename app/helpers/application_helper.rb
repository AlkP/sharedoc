module ApplicationHelper

  def edit_profile_user
    @user = User.find(session[:user_id])
  end

  def new_user
    @user = User.new
  end

  def create_session
    @user_session = Session.new
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update(user_params)
      redirect_to root_path
    else
      render '#login_modal'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :salt, :encrypted_password, :country)
  end

end
