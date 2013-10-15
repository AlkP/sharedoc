class Document < ActiveRecord::Base

  belongs_to :user

  has_attached_file :file

  has_many :shares, dependent: :destroy

end
