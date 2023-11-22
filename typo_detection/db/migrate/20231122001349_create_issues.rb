class CreateIssues < ActiveRecord::Migration[7.1]
  def change
    create_table :issues do |t|
      t.integer     :page_id, limit: 8
      t.text        :sentence
      t.string      :message
      t.timestamps
    end
    add_index :issues, [:page_id]
  end
end
