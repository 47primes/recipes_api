class CreateCooks < ActiveRecord::Migration
  def change
    create_table :cooks do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :auth_key
      t.timestamps
    end
    
    add_index(:cooks, :username, :unique => true)
    add_index(:cooks, :email, :unique => true)
    add_index(:cooks, :auth_key, :unique => true)
  end
end
