class DocumentsController < ApplicationController

  def my_doc
    Document.find_by_sql(["SELECT * FROM Documents WHERE user_id=?;", session[:user_id]])
  end

  def shared_with_me
    @user_email = current_user.email
    #@share = Share.find_all_by_name(@user_email)
    @share = Share.find_by_sql(["SELECT * FROM Shares WHERE name=?;", @user_email])
    temp = []
    @share.each do |qq|
      temp.append(qq.document_id)
    end
    Document.find_by_sql(["SELECT * FROM Documents WHERE id IN (?);", temp])
  end

  def add_share_for_doc
    @document = Document.find(params[:shares_for])
    # :shares - id document
    # session[:user_id] - id user
    @user = User.find(session[:user_id])

    @user_to = User.find_by_email(params[:user])
    if @user_to.nil?
      @url = "#{request.protocol}#{request.host_with_port}/"
      UserMailer.shared_email(params[:user], @user, @url).deliver
    else
      @url = "#{request.protocol}#{request.host_with_port}/"
      UserMailer.new_shared_email(params[:user], @user, @url).deliver
    end

    #@shared = Share.create(:name => @user.email, :user_id => session[:user_id], :document_id => params[:shares])
    @shared = Share.create(:name => params[:user], :user_id => session[:user_id], :document_id => params[:shares_for])

    @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
    @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
    @description = @user.email + ' shared document "' + @document.name + '" with ' + params[:user]
    @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'share_create', :description => @description )
    @activities.save

    @shared.save
    redirect_to :back
  end

  def index
    current_page_set("documents")
    if !(params[:shares_pre]).nil?
      @document_preview_name = (Document.find(params[:shares_pre])).name
    end
    if !(params[:shares_for]).nil?
      add_share_for_doc
    end
    #puts "qwe" * 100
    #puts params[:shares_pre]
    @share_new_id = params[:shares_pre]
    @share_new = Share.new
    @share_doc = Share.find_by_sql(["SELECT * FROM Shares WHERE document_id=?;", params[:shares_pre]])
    if params[:filter] == 'my'
      @document = my_doc
    elsif params[:filter] == 'shared'
      @document = shared_with_me
    else
      @document = my_doc + shared_with_me
    end
    #@document = my_doc + shared_with_me
  end

  def share
    @user_email = current_user.email
    #@share = Share.find_all_by_name(@user_email)
    @share = Share.find_by_sql(["SELECT * FROM Shares WHERE name=?;", @user_email])

    temp = []
    @share.each do |qq|
      temp.append(qq.document_id)
    end

    @document = Document.find_by_sql(["SELECT * FROM Documents WHERE id IN (?);", temp])
  end


  def show
    @document = Document.find(params[:id])
  end

  def new
    @document = Document.new
  end

  def create
    @user = User.find(session[:user_id])
    @document = @user.documents.new(document_params)


    #@document = Document.new(document_params)

    if @document.save
      @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
      @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
      @description = @user.email + ' create document "' + @document.name + '"'
      @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'document_create', :description => @description )
      @activities.save
      redirect_to documents_path
    else
      render 'new'
    end
    # метод для постинга формы
    #render :json => @document.to_json(methods: [:errors])
  end

  def edit
    @document = Document.find(params[:id])
  end

  def update
    @document = Document.find(params[:id])

    if @document.update(document_params)

      @user = User.find(session[:user_id])
      @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
      @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
      @description = @user.email + ' update the document "' + @document.name + '"'
      @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'document_update', :description => @description )
      @activities.save

      redirect_to documents_path
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(session[:user_id])
    @document = Document.find(params[:id])
    @date_e =  (/\d*-\d*-\d*/.match(Time.now.to_s)).to_s
    @time_e =  (/\d*:\d*:\d*/.match(Time.now.to_s)).to_s
    @description = @user.email + ' destroy the document "' + @document.name + '"'
    @activities = Activities.create(:name => @user.email, :date => @date_e, :time => @time_e, :type_activities => 'document_destroy', :description => @description )
    @activities.save

    @document.destroy

    redirect_to documents_path
  end

  private
  def select_doc(params)


  end

  def document_params
    params.require(:document).permit(:name, :description, :file, :user_id)
  end

end
