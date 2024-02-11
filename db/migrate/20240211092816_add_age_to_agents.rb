class AddAgeToAgents < ActiveRecord::Migration[7.1]
  def change
    add_column :agents, :monthly_amount_revenue, :integer
  end
end
