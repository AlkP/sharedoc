class Activities < ActiveRecord::Base

  scope :scope_by_type, lambda { |type|
    where('type_activities = ?', type)
  }

end
