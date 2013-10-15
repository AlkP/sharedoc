class SessionsController < ApplicationController
  def new
  end

  def index
    render :action => :new
  end

  def create
    user = User.authenticate(params[:email], params[:password])
    if user
      @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
      @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
      #@activities = Activities.create(:name => params[:email], :date => @sel)
      @description = user.email + ' is logged'
      @activities = Activities.create(:name => user.email , :date => @date_e, :time => @time_e, :type_activities => 'log_in', :description => @description )
      @activities.save
      session[:user_id] = user.id
      redirect_to root_url, :notice => "Logged in!"
      @session_user_id = user.id
    else
      flash.now.alert = "Invalid email or password"
      render "new"
      #redirect_to "/"
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logged out!"
  end

end
