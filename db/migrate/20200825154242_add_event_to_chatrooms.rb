class AddEventToChatrooms < ActiveRecord::Migration[6.0]
  def change
    add_reference :chatrooms, :event, foreign_key: true
  end
end
