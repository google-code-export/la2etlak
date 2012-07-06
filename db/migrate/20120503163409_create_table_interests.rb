class CreateTableInterests < ActiveRecord::Migration
  def up
    create_table :interests do |t|
      t.string :name
      t.string :description
      t.boolean :deleted
      t.string :image
          
      t.timestamps
    end
  end

  def down
   drop_table :interests
  end
end
