class AddColumnShortenedUrl < ActiveRecord::Migration[7.0]
  def change
    add_column :shortened_urls, :user_id, :bigint
  end
end
