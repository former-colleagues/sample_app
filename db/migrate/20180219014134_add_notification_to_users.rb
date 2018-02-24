class AddNotificationToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :notification, :boolean, default: true
  end
end
