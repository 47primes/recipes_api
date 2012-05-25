class CreateCookbooks < ActiveRecord::Migration
  def change
    create_table :cookbooks do |t|
      t.integer :cook_id
      t.string :name
      t.string :description
      t.timestamps
    end
    add_index :cookbooks, :cook_id
    add_index :cookbooks, :name
    add_index :cookbooks, :description
  end
end
