class CreateAnnouncements < ActiveRecord::Migration[7.1]
  def change
    create_table :announcements do |t|
      t.string :title, null: false
      t.text :description, null: false
      t.decimal :price, precision: 10, scale: 2, null: false
      t.integer :status, default: 0, null: false
      t.integer :condition, null: false
      t.integer :views_count, default: 0, null: false
      t.references :seller, null: false, foreign_key: { on_delete: :cascade }
      t.references :category, null: false, foreign_key: { on_delete: :restrict }
      t.string :location

      t.timestamps
    end

    # Performance indexes
    add_index :announcements, :status
    add_index :announcements, :created_at
    add_index :announcements, [:status, :created_at]
    add_index :announcements, :views_count
    add_index :announcements, :price
  end
end
