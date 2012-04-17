class AddEntriesIndex < ActiveRecord::Migration
  def up
    add_index "entry_translations", ["term"], :name => "index_entry_translations_on_term"
  end

  def down
    remove_index "entry_translations", :name => "index_entry_translations_on_term"
  end
end
