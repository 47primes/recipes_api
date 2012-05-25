class CreateRecipes < ActiveRecord::Migration
  def change
    create_table :recipes do |t|
      t.integer :cook_id
      t.integer :cookbook_id
      t.string :name
      t.string :category
      t.text :ingredients
      t.text :directions
      t.timestamps
    end
    add_index :recipes, :cook_id
    add_index :recipes, :cookbook_id
    add_index :recipes, :name
  end
end
