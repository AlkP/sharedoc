class CreateShares < ActiveRecord::Migration
  def change
    create_table :shares do |t|
      t.string :name
      t.references :user, index: true
      t.references :document, index: true

      t.timestamps
    end
  end
end
