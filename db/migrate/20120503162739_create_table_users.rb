class CreateTableUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.string :name
      t.string :first_name
      t.string :last_name
      t.date :date_of_birth
      t.string :email
      t.boolean :deactivated , :default => false
      t.string :image
          
      t.timestamps
    end
  end

  def down
   drop_table :users
  end
end
