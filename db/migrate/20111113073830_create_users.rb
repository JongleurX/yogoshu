class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :encrypted_password, :limit => 40
      t.string :salt, :limit => 40

      t.timestamps
    end
  end
end
