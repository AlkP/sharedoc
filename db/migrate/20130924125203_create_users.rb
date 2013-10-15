class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.string :country

      t.timestamps
    end

    add_index :users, :email, :unique => true

  end
end
