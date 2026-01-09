class AddAnnouncementsCountToSellers < ActiveRecord::Migration[7.1]
  def change
    add_column :sellers, :announcements_count, :integer, default: 0, null: false

    # Backfill existing counts
    reversible do |dir|
      dir.up do
        execute <<-SQL
          UPDATE sellers
          SET announcements_count = (
            SELECT COUNT(*)
            FROM announcements
            WHERE announcements.seller_id = sellers.id
          )
        SQL
      end
    end
  end
end
