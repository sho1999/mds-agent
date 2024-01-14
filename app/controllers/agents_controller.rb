class AgentsController < ApplicationController
  # def mypage
  #   @agent = current_agent
  
  #   # 現在の年と月を取得し、その月の初日と最終日を取得
  #   year = Date.today.year
  #   month = Date.today.month
  #   start_date = Date.new(year, month, 1)
  #   end_date = start_date.end_of_month
  
  #   # その月の全ての日付の範囲を作成
  #   all_dates = (start_date..end_date).to_a
  
  #   # データベースからのデータを取得
  #   daily_reports_data = DailyReport.where(agent_id: @agent.id, date: start_date..end_date)
  #                                   .order(:date)
  #                                   .pluck(:date, :dms, :appointments)
  
  #   # 日付毎のDM数とアポイントメント数をハッシュで格納
  #   data_by_date = daily_reports_data.map { |report| [report[0], { dms: report[1], appointments: report[2] }] }.to_h
  
  #   # 全ての日付について、DM数とアポイントメント数を割り当て
  #   @dates = all_dates.map { |date| date.strftime('%d') }
  #   @appointments_data = all_dates.map { |date| data_by_date[date]&.dig(:dms) || 0 }
  #   @dms_data = all_dates.map { |date| data_by_date[date]&.dig(:appointments) || 0 }

  #   # 月間の合計を計算
  #   @total_dms = daily_reports.sum(:dms)
  #   @total_appointments = daily_reports.sum(:appointments)
  #   @total_contracts = daily_reports.sum(:contracts)
  # end

  def mypage
    @agent = current_agent
  
    # 現在の年と月を取得し、その月の初日と最終日を取得
    year = Date.today.year
    month = Date.today.month
    start_date = Date.new(year, month, 1)
    end_date = start_date.end_of_month
  
    # その月の全ての日付の範囲を作成
    all_dates = (start_date..end_date).to_a
  
    # データベースからのデータを取得（インスタンス変数に変更）
    @daily_reports = DailyReport.where(agent_id: @agent.id, date: start_date..end_date)
  
    # 日付毎のDM数とアポイントメント数、契約数をハッシュで格納
    data_by_date = @daily_reports.map { |report| [report.date, { dms: report.dms, appointments: report.appointments, contracts: report.contracts }] }.to_h
  
    # 全ての日付について、DM数とアポイントメント数、契約数を割り当て
    @dates = all_dates.map { |date| date.strftime('%d') }
    @dms_data = all_dates.map { |date| data_by_date[date]&.dig(:dms) || 0 }
    @appointments_data = all_dates.map { |date| data_by_date[date]&.dig(:appointments) || 0 }
  
    # 月間の合計を計算
    @total_dms_this_month = @daily_reports.sum(:dms)
    @total_appointments_this_month = @daily_reports.sum(:appointments)
    @total_contracts_this_month = @daily_reports.sum(:contracts)
    
     # 月間契約数と全期間契約数の合計
    @total_contracts = @agent.total_contracts
    @total_appointments = @agent.total_appointments
    @total_dms = @agent.total_dms

  end
end
  