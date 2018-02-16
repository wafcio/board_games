class CreateAuthentications < ActiveRecord::Migration[5.1]
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
    end

    add_index :authentications, [:provider, :uid], unique: true
  end
end
