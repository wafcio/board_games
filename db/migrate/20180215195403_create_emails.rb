class CreateEmails < ActiveRecord::Migration[5.1]
  def change
    create_table :emails do |t|
      t.integer :user_id
      t.string :email
      t.boolean :primary, default: false

      ## Confirmable
      t.string :unconfirmed_email
      t.string :confirmation_token
      t.datetime :confirmed_at
      t.datetime :confirmation_sent_at
    end
  end
end
