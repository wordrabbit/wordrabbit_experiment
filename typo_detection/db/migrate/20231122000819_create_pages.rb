class CreatePages < ActiveRecord::Migration[7.1]
  def change
    create_table :pages do |t|
      t.integer     :site_id, limit: 8
      t.string      :url
      t.boolean     :is_scraped, default: false
      t.boolean     :is_scanned, default: false
      t.text        :body
      t.timestamps
    end
    add_index :pages, [:site_id]
    add_index :pages, [:url]
  end
end
