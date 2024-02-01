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

  def calculate_progress
    # ポイントの計算
    total_points = (self.total_dms / 10) + (self.total_appointments * 5) + (self.total_contracts * 30)

    level_thresholds = [0, 30, 60, 100, 150, 210, 280, 360, 450, 550]

    # ユーザーの現在のレベルと進捗度を計算
    current_level = level_thresholds.index { |threshold| total_points < threshold } || level_thresholds.size

    if current_level > 0
      points_for_next_level = level_thresholds[current_level] - level_thresholds[current_level - 1]
      progress_within_level = total_points - level_thresholds[current_level - 1]
      level_progress = (progress_within_level.to_f / points_for_next_level * 100).round
    else
      # 最低レベル（レベル1）の場合、進捗度を0%とする
      level_progress = 0
    end

    return current_level, level_progress
  end
  
end