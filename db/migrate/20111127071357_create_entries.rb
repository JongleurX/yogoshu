class CreateEntries < ActiveRecord::Migration
  def self.up
    create_table :entries do |t|
      t.integer :user_id
      t.string :note
      t.boolean :approved
      t.string :source_language, :limit => 2

      t.timestamps
    end
    Entry.create_translation_table! :term => :string
  end

  def self.down
    drop_table :entries
    Entry.drop_translation_table!
  end

end
