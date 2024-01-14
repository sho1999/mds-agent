class Agent < ApplicationRecord
  # deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # DailyReportモデルとの関連付け
  has_many :daily_reports

  def total_contracts
    DailyReport.where(agent_id: id).sum(:contracts)
  end

  def total_dms
    DailyReport.where(agent_id: id).sum(:dms)
  end

  def total_appointments
    DailyReport.where(agent_id: id).sum(:appointments)
  end
end