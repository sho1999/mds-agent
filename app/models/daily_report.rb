class DailyReport < ApplicationRecord
  belongs_to :agent  # Agencyではなく、Agentに属していると仮定

  validate :unique_date_for_agency
  validates :date, presence: true
  validates :appointments, presence: true
  validates :dms, presence: true

  private

  def unique_date_for_agency
    if DailyReport.where(agent_id: agent_id, date: date).exists?
      errors.add(:date, 'は既に存在しています。')
    end
  end
end