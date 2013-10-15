class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
      @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
      @description = user_params[:email] + ' registered in the system'
      @activities = Activities.create(:name => user_params[:email], :date => @date_e, :time => @time_e, :type_activities => 'sign_up', :description => @description )
      @activities.save
      @description = user_params[:email] + ' is logged'
      @activities = Activities.create(:name => user_params[:email] , :date => @date_e, :time => @time_e, :type_activities => 'log_in', :description => @description )
      @activities.save
      session[:user_id] = @user.id
      @url = "#{request.protocol}#{request.host_with_port}/"
      UserMailer.welcome_email(@user, @url).deliver
      redirect_to root_url, :notice => "Signed up!"
    else
      #redirect_to "/"
      render "new"
    end
  end

  def edit
    @user = User.find(session[:user_id])
  end

  def update
    @user = User.find(session[:user_id])
    if @user.update(user_params)
      redirect_to root_path
    else
      render 'edit'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :salt, :encrypted_password, :country)
  end

end
