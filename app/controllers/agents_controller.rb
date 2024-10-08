class AgentsController < ApplicationController
  before_action :authenticate_agent!

  def mypage
    @agent = current_agent
    @agents = Agent.joins(:daily_reports)
    .where(daily_reports: { date: Time.current.beginning_of_month..Time.current.end_of_month })
    .group('agents.id')
    .select('agents.*, SUM(daily_reports.appointments) AS total_appointments_count, SUM(daily_reports.dms) AS total_dms_count')
    .order('total_appointments_count DESC, total_dms_count DESC')
    .limit(3)

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
  
    #初期化
    @total_contracts_this_month = @daily_reports.sum(:contracts)
    
    #月間契約数と全期間契約数の合計
    @total_contracts = @agent.total_contracts
    @total_appointments = @agent.total_appointments
    @total_dms = @agent.total_dms

    @current_level, @level_progress = @agent.calculate_progress
  end

  def task
    @agent = current_agent
  end

  def top
  end

  def appointment
    @my_appointments = SpreadsheetService.get_my_appointments(current_agent.agent_id)      
  end

  def onboarding
    @agent = current_agent
  end

  def set_target
    @agent = current_agent
  end

  def update
    @agent = Agent.find(params[:id])
    if @agent.update(agent_params)
      redirect_to mypage_agent_path(@agent), notice: 'Agent was successfully updated.'
    else
      render :edit
    end
  end

  private

  def agent_params
    params.require(:agent).permit(:monthly_amount_revenue)
  end
end
  