class AddLocaleToVersion < ActiveRecord::Migration
  def change
    add_column :versions, :locale, :string
  end
end