class RemoveSourceLanguageFromEntry < ActiveRecord::Migration
  def change
    remove_column :entries, :source_language
  end
end
