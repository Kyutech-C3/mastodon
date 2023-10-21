class CreateRequestCustomEmojis < ActiveRecord::Migration[6.1]
  def change
    create_table :request_custom_emojis do |t|
      t.integer :state, null: false, default: 0
      t.string :shortcode, null: false, default: ''
      t.string :image_file_name
      t.string :image_content_type
      t.integer :image_file_size
      t.datetime :image_updated_at
      t.integer :image_storage_schema_version
      t.bigint :account_id

      t.timestamps null: false
    end
    add_foreign_key :request_custom_emojis, :accounts, column: :account_id, primary_key: :id, on_update: :cascade, on_delete: :cascade, validate: false
  end
end
