class CreateTableVerificationCodes < ActiveRecord::Migration
  def up
    create_table :verification_codes  do |t|
      t.integer :user_id
      t.string :code
      t.boolean :verified
          
      t.timestamps
    end
  end

  def down
   drop_table :verification_codes 
  end
end
