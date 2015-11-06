class AddMonetaryUnitToUsers < ActiveRecord::Migration
  def change
    add_column :users, :monetary_unit, :string, :default => "руб"
  end
end
