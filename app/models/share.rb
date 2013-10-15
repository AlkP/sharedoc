class Share < ActiveRecord::Base
  belongs_to :user
  belongs_to :document


  scope :share, lambda { |user_email|
    where('shares.name = ?', user_email) unless !user_email.nil?
  }

  scope :share_my, lambda { |user_id|
    where('shares.user_id = ?', user_id).group('document_id') unless !user_id.nil?
  }

end
