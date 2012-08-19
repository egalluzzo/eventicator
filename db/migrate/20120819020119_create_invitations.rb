class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.integer :event_id
      t.integer :inviting_user_id
      t.integer :invited_user_id
      t.string :invited_email
      t.boolean :accepted
      t.boolean :attended

      t.timestamps
    end

    add_index :invitations, :event_id
    add_index :invitations, :invited_user_id
    add_index :invitations, [:event_id, :accepted]
    add_index :invitations, [:event_id, :invited_user_id], unique: true
    add_index :invitations, [:event_id, :invited_email], unique: true
  end
end
