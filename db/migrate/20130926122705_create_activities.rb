class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
      t.string :name
      t.string :type_activities
      t.string :description
      t.string :date
      t.string :time

      t.timestamps
    end
  end
end
