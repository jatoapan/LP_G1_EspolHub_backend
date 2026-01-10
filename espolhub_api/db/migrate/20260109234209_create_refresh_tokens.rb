class CreateRefreshTokens < ActiveRecord::Migration[7.1]
  def change
    create_table :refresh_tokens do |t|
      t.references :seller, null: false, foreign_key: { on_delete: :cascade }
      t.string :token_digest, null: false
      t.string :jti, null: false
      t.datetime :expires_at, null: false
      t.datetime :revoked_at

      t.timestamps
    end

    add_index :refresh_tokens, :jti, unique: true
    add_index :refresh_tokens, :expires_at
    add_index :refresh_tokens, [:seller_id, :revoked_at]
  end
end
