class AddFileColumnsToDocuments < ActiveRecord::Migration
  #def change
  #end

  #def change
  #  create_table :documents do |t|
  #    t.attachment :avatar
      #t.attachment :file
    #end
  #end

  def self.up
    change_table :documents do |t|
      t.attachment :file
    end
  end

  #def self.up
  #  add_attachment :documents, :file
  #end

  def self.down
    remove_attachment :documents, :file
  end
end
