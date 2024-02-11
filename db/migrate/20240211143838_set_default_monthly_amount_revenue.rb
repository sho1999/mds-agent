class SetDefaultMonthlyAmountRevenue < ActiveRecord::Migration[7.1]
  def change
    change_column_default :agents, :monthly_amount_revenue, from: nil, to: 0
  end
end
