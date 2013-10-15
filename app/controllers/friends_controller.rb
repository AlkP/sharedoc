class FriendsController < ApplicationController
  def index
    current_page_set("friends")
    @friend_new = Friend.new
    @friend = Friend.find_by_sql(["SELECT * FROM Friends WHERE user_id=?;", current_user.id])
  end

  def create
    @user = User.find(session[:user_id])
    @friend = @user.friends.new(friend_params)

    @user_to = User.find_by_email(@friend.name)
    if @user_to.nil?
      @url = "#{request.protocol}#{request.host_with_port}/"
      UserMailer.invite_email(@friend.name, @user, @url).deliver
    end

    #@document = Document.new(document_params)

    if @friend.save
      @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
      @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
      @description = @user.email + ' add new friend "' + @friend.name + '"'
      @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'friend_add', :description => @description )
      @activities.save
      redirect_to friends_path
    else
      render 'index'
    end
    # метод для постинга формы
    #render :json => @document.to_json(methods: [:errors])
  end

  def destroy
    @user = User.find(session[:user_id])
    @friend = Friend.find(params[:id])
    @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
    @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
    @description = @user.email + ' delete from friends "' + @friend.name + '"'
    @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'document_destroy', :description => @description )
    @activities.save

    @friend.destroy

    redirect_to friends_path
  end

  private

  def friend_params
    params.require(:friend).permit(:name, :user_id)
  end

end
