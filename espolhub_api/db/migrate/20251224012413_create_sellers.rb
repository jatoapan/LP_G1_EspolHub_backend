class CreateSellers < ActiveRecord::Migration[7.1]
  def change
    create_table :sellers do |t|
      t.string :name, null: false
      t.string :email, null: false
      t.string :phone, null: false
      t.string :faculty, null: false
      t.string :whatsapp_link
      t.string :password_digest, null: false

      t.timestamps
    end

    add_index :sellers, :email, unique: true
    add_index :sellers, :phone, unique: true
  end
end