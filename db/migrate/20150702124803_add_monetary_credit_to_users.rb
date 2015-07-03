class AddMonetaryCreditToUsers < ActiveRecord::Migration
  def change
    add_column :users, :monetary_credit, :integer, :default => 0
  end
end
