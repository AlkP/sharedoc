class DashboardController < ApplicationController

  def my_activities
    Activities.find_by_sql(["select * from activities where name=?;",current_user.email])
  end

  def activities_my_friend
    @user_id = current_user.id
    #puts "qwe" * 100
    #puts  @user_id
    @activities_friends = Friend.find_by_sql(["SELECT * FROM Friends WHERE user_id=?;", @user_id])
    temp = []
    @activities_friends.each do |qq|
      temp.append(qq.name)
    end
    Activities.find_by_sql(["SELECT * FROM Activities WHERE name IN (?);", temp])
  end

  def index
    if current_user
      @activities = my_activities + activities_my_friend
    end
    #@activities = Activities.all
  end

end
