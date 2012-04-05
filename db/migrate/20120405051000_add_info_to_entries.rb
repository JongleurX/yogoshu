class AddInfoToEntries < ActiveRecord::Migration
  def change
    add_column :entries, :info, :text
  end
end
