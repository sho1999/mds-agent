class UpdateExistingMonthlyAmountRevenue < ActiveRecord::Migration[7.1]
  def up
    Agent.where(monthly_amount_revenue: nil).update_all(monthly_amount_revenue: 0)
  end

  def down
    # 既存の値を0に更新する変更を元に戻すことはできないため、ここは空です。
  end
end
