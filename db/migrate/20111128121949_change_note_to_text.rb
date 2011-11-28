class ChangeNoteToText < ActiveRecord::Migration
  def up
    remove_column :entries, :note
    add_column :entries, :note, :text
  end

  def down
    remove_column :entries, :note
    add_column :entries, :note, :string
  end
end
