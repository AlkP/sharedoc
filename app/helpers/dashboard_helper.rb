module DashboardHelper

  def geo_chart
    #user_by_country = User.find_by_sql(["select country, count(id) from users group by country;"])

    user_by_country = User.count(:group => ['country'])

    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Country')
    data_table.new_column('number', 'Users')
    data_table.add_rows(user_by_country.size)
    line = 0
    user_by_country.each do |country,users_count|
      data_table.set_cell(line, 0, country)
      data_table.set_cell(line, 1, users_count)
      line = line + 1
    end

    #data_table = GoogleVisualr::DataTable.new
    #data_table.new_column('string', 'Country')
    #data_table.new_column('number', 'Popularity')
    #data_table.add_rows(6)
    #data_table.set_cell(0, 0, 'Germany')
    #data_table.set_cell(0, 1, 200)
    #data_table.set_cell(1, 0, 'United States')
    #data_table.set_cell(1, 1, 300)
    #data_table.set_cell(2, 0, 'Brazil')
    #data_table.set_cell(2, 1, 400)
    #data_table.set_cell(3, 0, 'Canada')
    #data_table.set_cell(3, 1, 500)
    #data_table.set_cell(4, 0, 'France')
    #data_table.set_cell(4, 1, 600)
    #data_table.set_cell(5, 0, 'Russian Federation')
    #data_table.set_cell(5, 1, 700)

    opts   = { :title=> 'World Performance'  }
    @chart = GoogleVisualr::Interactive::GeoChart.new(data_table, opts)
    #@chart = GoogleVisualr::Interactive::GeoMap.new(data_table, opts)

  end

  def count_dash
    @user_email = current_user.email
    @share = Share.find_by_sql(["SELECT * FROM Shares WHERE name=?;", @user_email])

    @my_doc = (Document.find_by_sql(["select * from documents where user_id=?;", session[:user_id]])).size.to_s
    @my_shared_doc = (Document.find_by_sql(["select * from shares where user_id=? group by document_id;", session[:user_id]])).size.to_s
    @with_me_shared_doc = (@share).size.to_s
  end

  def column_chart
    @user_email = current_user.email
    #@share = Share.find_by_sql(["SELECT * FROM Shares WHERE name=?;", @user_email])


    @my_doc = (Document.find_by_sql(["select * from documents where user_id=?;", session[:user_id]])).size
    #@my_shared_doc = (Document.find_by_sql(["select * from shares where user_id=? group by document_id;", session[:user_id]])).size
    @my_shared_doc = (Share.count(:conditions => ["shares.user_id = ?", session[:user_id]], :group => ["document_id"])).size


    #@with_me_shared_doc = Share.count(:conditions=>["shares.name = ?", @user_email], :order => 'DATE(created_at) DESC', :group => ["DATE(created_at)"])
    @with_me_shared_doc = (Share.count(:conditions => ["shares.name = ?", @user_email], :group => ["document_id"])).size
    data_table = GoogleVisualr::DataTable.new
    data_table.new_column('string', 'Documents')
    data_table.new_column('number', 'My documents')
    data_table.new_column('number', 'My shared documents')
    data_table.new_column('number', 'Shared with me documents')
    data_table.add_rows(1)
    data_table.set_cell(0, 0, 'Documents')
    data_table.set_cell(0, 1, @my_doc)
    data_table.set_cell(0, 2, @my_shared_doc)
    data_table.set_cell(0, 3, @with_me_shared_doc)
    #data_table.set_cell(1, 0, '2005')
    #data_table.set_cell(1, 1, 1170)
    #data_table.set_cell(1, 2, 460)
    #data_table.set_cell(2, 0, '2006')
    #data_table.set_cell(2, 1, 660)
    #data_table.set_cell(2, 2, 1120)
    #data_table.set_cell(3, 0, '2007')
    #data_table.set_cell(3, 1, 1030)
    #data_table.set_cell(3, 2, 540)

    opts   = { :title => 'Table activity work with doc', :hAxis => { :titleTextStyle => {:color => 'red'}} }
    @column_chart = GoogleVisualr::Interactive::ColumnChart.new(data_table, opts)

  end

  def area_chart
    data_table = GoogleVisualr::DataTable.new
    #@activities_log_in = Activities.count(:group => ['date'], :conditions => { :type_activities => ['log_in'] })
    @activities_log_in = (Activities.scope_by_type('log_in')).count(:group => ['date'])
    #@activities_sign_up = Activities.count(:group => ['date'], :conditions => { :type_activities => ['sign_up'] })
    @activities_sign_up = (Activities.scope_by_type('sign_up')).count(:group => ['date'])
    #@activities_shares = Activities.count(:group => ['date'], :conditions => { :type_activities => ['share_create'] })
    @activities_shares =  (Activities.scope_by_type('share_create')).count(:group => ['date'])
    data_table.new_column('string', 'Date' )
    data_table.new_column('number', 'Sign up')
    data_table.new_column('number', 'Login')
    data_table.new_column('number', 'Shared create')

    data_table.add_rows(@activities_log_in.size)
    line = 0
    @activities_log_in.each do |date2, users_count2|
      data_table.set_cell(line, 0, date2)
      data_table.set_cell(line, 1, 0)
      data_table.set_cell(line, 2, users_count2)
      data_table.set_cell(line, 3, 0)
      @activities_sign_up.each do |date1,users_count1|
        if date1 == date2
          data_table.set_cell(line, 1, users_count1)
        end
      end
      @activities_shares.each do |date3,users_count3|
        if date3 == date2
          data_table.set_cell(line, 3, users_count3)
        end
      end
      line = line + 1
    end

    opts   = {:title=> 'Users Activities'  }

    #@areachart = GoogleVisualr::Interactive::AreaChart.new(data_table, opts)
    @areachart = GoogleVisualr::Interactive::LineChart.new(data_table, opts)

  end

end
