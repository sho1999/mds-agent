class DailyReportsController < ApplicationController
    def new
      @daily_report = DailyReport.new
    end
  
    def create
      @daily_report = DailyReport.new(daily_report_params)
      @daily_report.agent_id = current_agent.id # 現在ログインしているAgentのIDをセット
      if @daily_report.save
        redirect_to mypage_agent_path(current_agent), notice: 'レポートが正常に作成されました。' # 適切なリダイレクト先に変更してください
      else
        render :new
      end
    end
  
    private
  
    def daily_report_params
      params.require(:daily_report).permit(:date, :dms, :appointments, :contracts)
    end
end