class CreateCategories < ActiveRecord::Migration[7.1]
  def change
    create_table :categories do |t|
      t.string :name, null: false
      t.text :description
      t.string :icon
      t.boolean :active, default: true, null: false

      t.timestamps
    end

    add_index :categories, :name, unique: true
    add_index :categories, :active
  end
end
