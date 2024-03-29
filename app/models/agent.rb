class Agent < ApplicationRecord
  # deviseの設定
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  
  # DailyReportモデルとの関連付け
  has_many :daily_reports

  validates :agent_id, presence: true, length: { is: 9 }, numericality: { only_integer: true }

  def total_contracts
    DailyReport.where(agent_id: id).sum(:contracts)
  end

  def total_dms
    DailyReport.where(agent_id: id).sum(:dms)
  end

  def total_appointments
    DailyReport.where(agent_id: id).sum(:appointments)
  end

  def monthly_contract_target(agent)
    agent.monthly_amount_revenue / 6000
  end

  def monthly_appointment_target(agent)
    agent.monthly_contract_target(agent) * 2.5
  end

  def monthly_dm_target(agent)
    agent.monthly_appointment_target(agent) * 50
  end

   # データベースからのデータを取得（インスタンス変数に変更）
  def total_dms_this_month(agent)
    year = Date.today.year
    month = Date.today.month
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    DailyReport.where(agent_id: agent.id, date: start_date..end_date).sum(:dms)
  end

  def total_appointments_this_month(agent)
    year = Date.today.year
    month = Date.today.month
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
    DailyReport.where(agent_id: agent.id, date: start_date..end_date).sum(:appointments)
  end



  def calculate_progress
    # ポイントの計算
    total_points = (self.total_dms / 10) + (self.total_appointments * 5) + (self.total_contracts * 30)

    level_thresholds = [0, 60, 120, 240, 480, 800, 1250, 1750, 2350, 3000]

    # ユーザーの現在のレベルと進捗度を計算
    current_level = level_thresholds.index { |threshold| total_points < threshold } || level_thresholds.size

    if current_level == 10
      points_for_next_level = 11
      progress_within_level = 0
      level_progress = 0
    elsif current_level > 0
      points_for_next_level = level_thresholds[current_level] - level_thresholds[current_level - 1]
      progress_within_level = total_points - level_thresholds[current_level - 1]
      level_progress = (progress_within_level.to_f / points_for_next_level * 100).round
    else
      level_progress = 0
    end

    return current_level, level_progress
  end
end