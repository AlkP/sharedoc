class AddUserColumnsToDocuments < ActiveRecord::Migration
  def change
    change_table :documents do |t|
      t.references :user, index: true
    end
  end
end
