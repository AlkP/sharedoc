class SharesController < ApplicationController
  def index
    @jjj = params[:shares]
    @share = Share.find_by_sql(["SELECT * FROM Shares WHERE document_id=?;", params[:shares]])
  end

  def destroy
    @share = Share.find(params[:id])

    @document = Document.find(@share.document_id)
    @user = User.find(session[:user_id])
    @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
    @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
    @description = @user.email + ' destroy shared from document "' + @document.name + '" with ' + @share.name
    @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'share_destroy', :description => @description )
    @activities.save

    @share.destroy

    redirect_to :back

  end

  def add

    #puts params
    #puts '123qqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqqq'

    @document = Document.find(params[:shares])
    # :shares - id document
    # session[:user_id] - id user
    @user = User.find(session[:user_id])
    #@shared = Share.create(:name => @user.email, :user_id => session[:user_id], :document_id => params[:shares])
    @shared = Share.create(:name => params[:user], :user_id => session[:user_id], :document_id => params[:shares])
    @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
    @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
    @description = @user.email + ' shared document "' + @document.name + '" with ' + params[:user]
    @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'share_create', :description => @description )
    @activities.save
    @shared.save


    redirect_to :back
  end

  def new
    @share = Share.new
  end

end
