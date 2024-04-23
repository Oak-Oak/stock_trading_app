class AddAccountValueToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :account_value, :integer, default: 100000
  end
end
